import 'package:finalproject/data/model/response/melihatjadwal_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/data/model/request/pasien/tambahpendaftaran_request_model.dart';
import 'package:finalproject/data/model/request/pasien/editpendaftaran_request_model.dart';
import 'package:finalproject/data/model/response/admin/melihatpendaftaran_response_model.dart';
import 'package:finalproject/data/repository/pendaftaran_repository.dart';
import 'package:finalproject/presentation/pasien/bloc/pendaftaran/pendaftaran_bloc.dart';
import 'package:finalproject/service/service_http_client.dart';

// Import JadwalBloc dan JadwalState Anda
import 'package:finalproject/presentation/admin/bloc/jadwal/jadwal_bloc.dart'; // <<< TAMBAHKAN INI
import 'package:finalproject/presentation/admin/bloc/jadwal/jadwal_event.dart'; // <<< TAMBAHKAN INI
import 'package:finalproject/presentation/admin/bloc/jadwal/jadwal_state.dart'; // <<< TAMBAHKAN INI


class PendaftaranScreen extends StatefulWidget {
  const PendaftaranScreen({super.key});

  @override
  State<PendaftaranScreen> createState() => _PendaftaranScreenState();
}

class _PendaftaranScreenState extends State<PendaftaranScreen> {
  late PendaftaranPasienBloc _pendaftaranPasienBloc;

  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _durasiController = TextEditingController();
  DateTime? _selectedTanggalPendaftaran;

  // Variabel untuk dropdown jadwal, menggunakan MelihatJadwalResponseModel
  MelihatJadwalResponseModel? _selectedJadwal;
  List<MelihatJadwalResponseModel> _availableJadwals = [];

  @override
  void initState() {
    super.initState();
    final ServiceHttpClient serviceHttpClient = ServiceHttpClient();
    _pendaftaranPasienBloc = PendaftaranPasienBloc(PendaftaranRepository(serviceHttpClient));
    _pendaftaranPasienBloc.add(FetchAllPendaftaran());

    // Panggil event LoadJadwals dari JadwalBloc
    // Pastikan JadwalBloc sudah tersedia di atas widget tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JadwalBloc>().add(const LoadJadwals());
    });
  }

  @override
  void dispose() {
    _pendaftaranPasienBloc.close();
    _keluhanController.dispose();
    _durasiController.dispose();
    super.dispose();
  }

  void _showAddPendaftaranDialog() {
    _keluhanController.clear();
    _durasiController.clear();
    _selectedTanggalPendaftaran = null;
    _selectedJadwal = null; // Reset jadwal yang dipilih

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tambah Pendaftaran Baru'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // DROPDOWN UNTUK ID JADWAL
                    // Pastikan _availableJadwals sudah terisi
                    DropdownButtonFormField<MelihatJadwalResponseModel>(
                      decoration: const InputDecoration(
                        labelText: 'Pilih Jadwal Konsultasi',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      value: _selectedJadwal,
                      items: _availableJadwals.map((jadwal) {
                        return DropdownMenuItem<MelihatJadwalResponseModel>(
                          value: jadwal,
                          child: Text(
                            '${jadwal.namaBidan ?? 'Bidan'} - '
                            '${jadwal.tanggal?.toLocal().toIso8601String().split('T')[0] ?? 'N/A'} '
                            '(${jadwal.startTime ?? 'N/A'} - ${jadwal.endTime ?? 'N/A'})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (MelihatJadwalResponseModel? newValue) {
                        setState(() { // setState lokal untuk update UI dialog
                          _selectedJadwal = newValue;
                        });
                      },
                      isExpanded: true,
                      hint: const Text('Pilih Jadwal'),
                      // Pastikan items tidak null atau kosong
                      // Jika _availableJadwals kosong, dropdown tidak akan bisa diklik
                      // Anda bisa menambahkan validator jika perlu
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _keluhanController,
                      decoration: const InputDecoration(labelText: 'Keluhan'),
                      maxLines: 3,
                    ),
                    TextField(
                      controller: _durasiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Durasi (menit)'),
                    ),
                    ListTile(
                      title: Text(
                        _selectedTanggalPendaftaran == null
                            ? 'Pilih Tanggal Pendaftaran'
                            : 'Tanggal Pendaftaran: ${_selectedTanggalPendaftaran!.toLocal().toIso8601String().split('T')[0]}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedTanggalPendaftaran ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && picked != _selectedTanggalPendaftaran) {
                          setState(() {
                            _selectedTanggalPendaftaran = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addPendaftaran();
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Tambah'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditPendaftaranDialog(MelihatPendaftaranResponseModel pendaftaran) {
    _keluhanController.text = pendaftaran.keluhan ?? '';
    _durasiController.text = pendaftaran.durasi?.toString() ?? '';
    _selectedTanggalPendaftaran = pendaftaran.tanggalPendaftaran;

    // Untuk edit, cari MelihatJadwalResponseModel yang cocok dengan jadwalId pendaftaran yang ada
    _selectedJadwal = _availableJadwals.firstWhereOrNull(
        (jadwal) => jadwal.id == pendaftaran.jadwalId);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Pendaftaran'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // DROPDOWN UNTUK ID JADWAL PADA EDIT
                    DropdownButtonFormField<MelihatJadwalResponseModel>(
                      decoration: const InputDecoration(
                        labelText: 'Pilih Jadwal Konsultasi',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      value: _selectedJadwal,
                      items: _availableJadwals.map((jadwal) {
                        return DropdownMenuItem<MelihatJadwalResponseModel>(
                          value: jadwal,
                          child: Text(
                            '${jadwal.namaBidan ?? 'Bidan'} - '
                            '${jadwal.tanggal?.toLocal().toIso8601String().split('T')[0] ?? 'N/A'} '
                            '(${jadwal.startTime ?? 'N/A'} - ${jadwal.endTime ?? 'N/A'})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (MelihatJadwalResponseModel? newValue) {
                        setState(() {
                          _selectedJadwal = newValue;
                        });
                      },
                      isExpanded: true,
                      hint: const Text('Pilih Jadwal'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _keluhanController,
                      decoration: const InputDecoration(labelText: 'Keluhan'),
                      maxLines: 3,
                    ),
                    TextField(
                      controller: _durasiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Durasi (menit)'),
                    ),
                    ListTile(
                      title: Text(
                        _selectedTanggalPendaftaran == null
                            ? 'Pilih Tanggal Pendaftaran'
                            : 'Tanggal Pendaftaran: ${_selectedTanggalPendaftaran!.toLocal().toIso8601String().split('T')[0]}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedTanggalPendaftaran ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && picked != _selectedTanggalPendaftaran) {
                          setState(() {
                            _selectedTanggalPendaftaran = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _editPendaftaran(pendaftaran.id!);
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Simpan Perubahan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addPendaftaran() {
    final int? durasi = int.tryParse(_durasiController.text);

    if (_selectedJadwal != null && _keluhanController.text.isNotEmpty && durasi != null && _selectedTanggalPendaftaran != null) {
      final TambahPendaftaranRequestModel request = TambahPendaftaranRequestModel(
        jadwalId: _selectedJadwal!.id!,
        keluhan: _keluhanController.text,
        durasi: durasi,
        tanggalPendaftaran: _selectedTanggalPendaftaran!,
        status: 'pending',
      );
      _pendaftaranPasienBloc.add(AddPendaftaran(request));
    } else {
      _showSnackbar('Mohon lengkapi semua field dan pilih jadwal.', isError: true);
    }
  }

  void _editPendaftaran(int pendaftaranId) {
    final int? durasi = int.tryParse(_durasiController.text);

    if (_selectedJadwal != null && _keluhanController.text.isNotEmpty && durasi != null && _selectedTanggalPendaftaran != null) {
      final EditPendaftaranRequestModel request = EditPendaftaranRequestModel(
        jadwalId: _selectedJadwal!.id!,
        keluhan: _keluhanController.text,
        durasi: durasi.toString(),
        tanggalPendaftaran: _selectedTanggalPendaftaran!,
      );
      _pendaftaranPasienBloc.add(EditPendaftaran(pendaftaranId, request));
    } else {
      _showSnackbar('Mohon lengkapi semua field dan pilih jadwal untuk edit.', isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pendaftaran Pasien'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: MultiBlocListener( // Gunakan MultiBlocListener jika mendengarkan lebih dari satu Bloc
        listeners: [
          // Listener untuk PendaftaranPasienBloc
          BlocListener<PendaftaranPasienBloc, PendaftaranPasienState>(
            bloc: _pendaftaranPasienBloc,
            listener: (context, state) {
              if (state is PendaftaranSuccess<List<MelihatPendaftaranResponseModel>>) {
                // Data daftar pendaftaran berhasil dimuat, tidak perlu SnackBar di sini
              } else if (state is PendaftaranSuccess<String>) {
                _showSnackbar(state.data);
                _pendaftaranPasienBloc.add(FetchAllPendaftaran());
              } else if (state is PendaftaranSuccess) {
                _showSnackbar('Operasi berhasil!');
                _pendaftaranPasienBloc.add(FetchAllPendaftaran());
              } else if (state is PendaftaranError) {
                _showSnackbar(state.message, isError: true);
              }
            },
          ),
          // Listener untuk JadwalBloc
          BlocListener<JadwalBloc, JadwalState>(
            listener: (context, state) {
              if (state is JadwalLoaded) {
                setState(() {
                  _availableJadwals = state.jadwals; // Isi daftar jadwal dari JadwalBloc
                });
                // Opsional: Jika Anda ingin secara otomatis memilih jadwal pertama
                // if (_availableJadwals.isNotEmpty && _selectedJadwal == null) {
                //   setState(() {
                //     _selectedJadwal = _availableJadwals.first;
                //   });
                // }
              } else if (state is JadwalError) {
                _showSnackbar('Gagal memuat jadwal: ${state.message}', isError: true);
              } else if (state is JadwalLoading) {
                 // Opsional: tampilkan indikator loading khusus untuk jadwal jika diperlukan
                 // log('JadwalBloc is loading...');
              }
            },
          ),
        ],
        child: BlocBuilder<PendaftaranPasienBloc, PendaftaranPasienState>(
          bloc: _pendaftaranPasienBloc,
          builder: (context, state) {
            if (state is PendaftaranLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PendaftaranSuccess<List<MelihatPendaftaranResponseModel>>) {
              if (state.data.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_note_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Anda belum memiliki pendaftaran.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tekan tombol (+) di bawah untuk membuat pendaftaran baru.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  final pendaftaran = state.data[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keluhan: ${pendaftaran.keluhan ?? 'Tidak diketahui'}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text('Jadwal ID: ${pendaftaran.jadwalId ?? 'N/A'}'),
                          Text('Tanggal Pendaftaran: ${pendaftaran.tanggalPendaftaran?.toLocal().toIso8601String().split('T')[0] ?? 'N/A'}'),
                          Text('Durasi: ${pendaftaran.durasi ?? 'N/A'} menit'),
                          Text('Status: ${pendaftaran.status ?? 'N/A'}'),
                          Text('Patient ID: ${pendaftaran.patientId ?? 'N/A'}'),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    if (pendaftaran.id != null) {
                                      _showEditPendaftaranDialog(pendaftaran);
                                    } else {
                                      _showSnackbar('ID Pendaftaran tidak tersedia untuk diedit.', isError: true);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    if (pendaftaran.id != null) {
                                      _pendaftaranPasienBloc.add(DeletePendaftaran(pendaftaran.id!));
                                    } else {
                                      _showSnackbar('ID Pendaftaran tidak tersedia untuk dihapus.', isError: true);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is PendaftaranError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Tekan tombol tambah untuk membuat pendaftaran baru.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPendaftaranDialog,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Extension untuk memudahkan pencarian di List
extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}