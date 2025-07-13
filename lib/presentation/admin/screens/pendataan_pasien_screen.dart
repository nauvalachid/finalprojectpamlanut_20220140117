import 'package:finalproject/presentation/admin/widget/pendataanpasien/pendataan_pasien_form.dart';
import 'package:finalproject/presentation/admin/widget/pendataanpasien/tambah_pasien_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/data/model/request/admin/editpasien_request_model.dart';
import 'package:finalproject/data/model/request/admin/tambahpasien_request_model.dart';
import 'package:finalproject/data/model/response/admin/melihatpasien_response_model.dart';
import 'package:finalproject/presentation/admin/bloc/pasien/pasien_bloc.dart';
import 'package:finalproject/presentation/admin/bloc/pasien/pasien_event.dart';
import 'package:finalproject/presentation/admin/bloc/pasien/pasien_state.dart';
import 'package:intl/intl.dart';

class PasienScreen extends StatefulWidget {
  const PasienScreen({super.key});

  @override
  State<PasienScreen> createState() => _PasienScreenState();
}

class _PasienScreenState extends State<PasienScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MelihatPasienResponseModel> _allPasien = [];
  List<MelihatPasienResponseModel> _filteredPasien = [];

  @override
  void initState() {
    super.initState();
    context.read<PasienBloc>().add(const GetPasienEvent());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterPasien(_searchController.text);
  }

  void _filterPasien(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPasien = List.from(_allPasien);
      } else {
        _filteredPasien = _allPasien
            .where((pasien) =>
                (pasien.nama?.toLowerCase().contains(query.toLowerCase()) ??
                    false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manajemen Pasien',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF1976D2),
              size: 28.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPasienPage()),
              );
            },
            tooltip: 'Tambah Pasien Baru',
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF1976D2),
              size: 28.0,
            ),
            onPressed: () {
              _searchController.clear();
              context.read<PasienBloc>().add(const GetPasienEvent());
            },
            tooltip: 'Refresh Daftar Pasien',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari pasien...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1976D2)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: () {
                          _searchController.clear();
                          _filterPasien('');
                          FocusScope.of(context).unfocus();
                        },
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2.0),
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<PasienBloc, PasienState>(
              listener: (context, state) {
                if (state is PasienError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is PasienAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Pasien ${state.pasien.nama ?? ''} berhasil ditambahkan!')),
                  );
                  context.read<PasienBloc>().add(const GetPasienEvent());
                } else if (state is PasienEdited) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Pasien ${state.pasien.nama ?? ''} berhasil diedit!')),
                  );
                  context.read<PasienBloc>().add(const GetPasienEvent());
                } else if (state is PasienDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  context.read<PasienBloc>().add(const GetPasienEvent());
                } else if (state is PasienLoaded) {
                  _allPasien = state.pasien;
                  _filterPasien(_searchController.text);
                }
              },
              builder: (context, state) {
                if (state is PasienLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PasienLoaded) {
                  if (_filteredPasien.isEmpty) {
                    return Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'Belum ada data pasien.'
                            : 'Tidak ada pasien dengan nama "${_searchController.text}".',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: _filteredPasien.length,
                    itemBuilder: (context, index) {
                      final pasien = _filteredPasien[index];
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF64B5F6),
                                Color(0xFF1976D2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              pasien.nama ?? 'Nama tidak diketahui',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Telepon: ${pasien.nomorTelepon ?? '-'}',
                                    style: const TextStyle(color: Colors.white70)),
                                Text('Kelamin: ${pasien.kelamin ?? '-'}',
                                    style: const TextStyle(color: Colors.white70))
                              ],
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white),
                                  onPressed: () =>
                                      _showAddEditPasienDialog(context, pasien: pasien),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  onPressed: () => _confirmDeletePasien(context, pasien),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (pasien.id != null) {
                                context
                                    .read<PasienBloc>()
                                    .add(GetPasienDetailEvent(pasien.id!));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('ID Pasien tidak tersedia.')),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is PasienDetailLoaded) {
                  final pasien = state.pasien;
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Detail Pasien',
                                  style: Theme.of(context).textTheme.headlineSmall),
                              const Divider(),
                              Text('ID: ${pasien.id ?? '-'}'),
                              Text('Nama: ${pasien.nama ?? '-'}'),
                              Text(
                                  'Tanggal Lahir: ${pasien.tanggalLahir != null ? DateFormat('dd/MM/yyyy').format(pasien.tanggalLahir!) : '-'}'),
                              Text('Kelamin: ${pasien.kelamin ?? '-'}'),
                              Text('Alamat: ${pasien.alamat ?? '-'}'),
                              Text('Nomor Telepon: ${pasien.nomorTelepon ?? '-'}'),
                              Text('Latitude: ${pasien.latitude ?? '-'}'),
                              Text('Longitude: ${pasien.longitude ?? '-'}'),
                              Text(
                                  'Dibuat: ${pasien.createdAt != null ? DateFormat('dd/MM/yyyy HH:mm').format(pasien.createdAt!) : '-'}'),
                              Text(
                                  'Diperbarui: ${pasien.updatedAt != null ? DateFormat('dd/MM/yyyy HH:mm').format(pasien.updatedAt!) : '-'}'),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<PasienBloc>()
                                        .add(const GetPasienEvent());
                                  },
                                  child: const Text('Kembali ke Daftar'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (state is PasienError) {
                  return Center(child: Text('Terjadi kesalahan: ${state.message}'));
                }
                return const Center(child: Text('Tekan tombol refresh untuk memuat data.'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: null,
    );
  }

  // Fungsi ini tetap untuk edit pasien (menggunakan dialog)
  void _showAddEditPasienDialog(BuildContext context,
      {MelihatPasienResponseModel? pasien}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(pasien == null ? 'Tambah Pasien Baru' : 'Edit Pasien'),
          content: SingleChildScrollView(
            child: PasienFormContent(
              pasien: pasien,
              onSave: (request) {
                if (request is TambahPasienRequestModel) {
                  context.read<PasienBloc>().add(AddPasienEvent(request));
                } else if (request is EditPasienRequestModel) {
                  if (pasien?.id != null) {
                    context
                        .read<PasienBloc>()
                        .add(EditPasienEvent(pasien!.id!, request));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('ID Pasien tidak tersedia untuk diedit.')),
                    );
                  }
                }
                Navigator.of(dialogContext).pop(); 
              },
            ),
          ),
          actions: const [], 
        );
      },
    );
  }

  void _confirmDeletePasien(
      BuildContext context, MelihatPasienResponseModel pasien) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content:
              Text('Apakah Anda yakin ingin menghapus pasien ${pasien.nama ?? 'ini'}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (pasien.id != null) {
                  context.read<PasienBloc>().add(DeletePasienEvent(pasien.id!));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('ID Pasien tidak tersedia untuk dihapus.')),
                  );
                }
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}