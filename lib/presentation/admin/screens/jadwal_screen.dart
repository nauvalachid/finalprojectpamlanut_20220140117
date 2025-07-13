import 'package:finalproject/core/constants/colors.dart';
import 'package:finalproject/data/model/response/melihatjadwal_response_model.dart';
import 'package:finalproject/data/repository/jadwal_repository.dart';
import 'package:finalproject/presentation/admin/widget/jadwal/editjadwal_screen.dart';
import 'package:finalproject/presentation/admin/widget/jadwal/tambahjadwal_screen.dart';
import 'package:finalproject/service/service_http_client.dart';
import 'package:flutter/material.dart';

enum DateSortOrder {
  none, 
  ascending, 
  descending, 
}

enum IdSortOrder {
  none, 
  ascending, 
}

class JadwalScreen extends StatefulWidget {
  final String authToken;

  const JadwalScreen({Key? key, required this.authToken}) : super(key: key);

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  late final JadwalRepository _jadwalRepository;
  List<MelihatJadwalResponseModel> _rawJadwals = []; 
  List<MelihatJadwalResponseModel> _displayedJadwals =
      []; 
  bool _isLoading = true;
  String? _errorMessage;

  DateSortOrder _currentDateSortOrder = DateSortOrder.none; 
  IdSortOrder _currentIdSortOrder = IdSortOrder.none;    

  final TextEditingController _idFilterController =
      TextEditingController(); 

  @override
  void initState() {
    super.initState();
    final ServiceHttpClient serviceHttpClient = ServiceHttpClient();
    _jadwalRepository = JadwalRepository(serviceHttpClient);
    _fetchAndApplyFilterAndSort();
    _idFilterController.addListener(_applyFilterAndSort); 
  }

  @override
  void dispose() {
    _idFilterController.removeListener(_applyFilterAndSort);
    _idFilterController.dispose();
    super.dispose();
  }

  Future<void> _fetchAndApplyFilterAndSort() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _rawJadwals = await _jadwalRepository.getJadwals(); 
      _applyFilterAndSort(); 
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilterAndSort() {
    List<MelihatJadwalResponseModel> filteredAndSortedList =
        List.from(_rawJadwals);

    final String filterIdText = _idFilterController.text.trim();
    if (filterIdText.isNotEmpty) {
      filteredAndSortedList = filteredAndSortedList.where((jadwal) {
        return jadwal.id?.toString().contains(filterIdText) ?? false;
      }).toList();
    }

    if (_currentIdSortOrder == IdSortOrder.ascending) {
      filteredAndSortedList.sort((a, b) {
        if (a.id == null && b.id == null) return 0;
        if (a.id == null) return 1; 
        if (b.id == null) return -1; 
        return a.id!.compareTo(b.id!); 
      });
    } else if (_currentDateSortOrder == DateSortOrder.ascending) {
      filteredAndSortedList.sort((a, b) {
        final int dateComparison =
            (a.tanggal ?? DateTime(0)).compareTo(b.tanggal ?? DateTime(0));
        if (dateComparison != 0) {
          return dateComparison;
        }
        return (a.startTime ?? '').compareTo(b.startTime ?? '');
      });
    } else if (_currentDateSortOrder == DateSortOrder.descending) {
      filteredAndSortedList.sort((a, b) {
        final int dateComparison =
            (b.tanggal ?? DateTime(0)).compareTo(a.tanggal ?? DateTime(0));
        if (dateComparison != 0) {
          return dateComparison;
        }
        return (b.startTime ?? '').compareTo(a.startTime ?? '');
      });
    }

    setState(() {
      _displayedJadwals = filteredAndSortedList; 
    });
  }

  Future<void> _navigateToAddJadwalScreen() async {
    final bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddJadwalScreen()),
    );

    if (result == true) {
      _fetchAndApplyFilterAndSort(); 
    }
  }

  Future<void> _showEditJadwalDialog(MelihatJadwalResponseModel jadwal) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return EditJadwalDialog(
          jadwal: jadwal,
          onSave: (request) async {
            if (jadwal.id == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('ID Jadwal tidak tersedia untuk diedit.')),
              );
              return;
            }

            try {
              final response =
                  await _jadwalRepository.editJadwal(jadwal.id!, request);
              debugPrint('Jadwal diedit: ${response.namaBidan}');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Jadwal ${response.namaBidan ?? ''} berhasil diedit!'),
                  ),
                );
                _fetchAndApplyFilterAndSort(); 
              }
            } catch (e) {
              debugPrint('Gagal mengedit jadwal: $e');
              if (mounted) {
                String errorMessage = 'Gagal mengedit jadwal: ${e.toString()}';
                if (e.toString().contains('422')) {
                  errorMessage =
                      'Gagal mengedit jadwal: Pastikan format waktu adalah HH:MM (misal: 14:30) dan semua field terisi dengan benar.';
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
              }
            }
          },
        );
      },
    );
  }

  void _confirmDeleteJadwal(
      BuildContext context, MelihatJadwalResponseModel jadwal) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), 
          ),
          title: const Text(
            'Konfirmasi Hapus',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary, 
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus jadwal ini?',
            style: TextStyle(
              color: Colors.black87, 
              fontSize: 16.0,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.primary, 
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10), 
                elevation: 2, 
              ),
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFF5252), 
                foregroundColor: Colors.white, 
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10), 
                elevation: 2, 
              ),
              child: const Text('Hapus'),
              onPressed: () {
                if (jadwal.id != null) {
                  _deleteJadwal(jadwal.id!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('ID Jadwal tidak tersedia untuk dihapus.')),
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

  Future<void> _deleteJadwal(int id) async {
    try {
      final success = await _jadwalRepository.deleteJadwal(id);
      if (success) {
        debugPrint('Jadwal berhasil dihapus!');
        _fetchAndApplyFilterAndSort(); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil dihapus!')),
        );
      }
    } catch (e) {
      debugPrint('Gagal menghapus jadwal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus jadwal: ${e.toString()}')),
      );
    }
  }

  void _showSortOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Urutkan ID (Terkecil)'),
                trailing: _currentIdSortOrder == IdSortOrder.ascending
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _currentIdSortOrder = IdSortOrder.ascending;
                    _currentDateSortOrder = DateSortOrder.none; 
                  });
                  _applyFilterAndSort();
                  Navigator.pop(context); 
                },
              ),
              const Divider(), 
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Urutkan Tanggal (Terlama)'),
                trailing: _currentDateSortOrder == DateSortOrder.ascending
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _currentDateSortOrder = DateSortOrder.ascending;
                    _currentIdSortOrder = IdSortOrder.none; 
                  });
                  _applyFilterAndSort();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Urutkan Tanggal (Terbaru)'),
                trailing: _currentDateSortOrder == DateSortOrder.descending
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _currentDateSortOrder = DateSortOrder.descending;
                    _currentIdSortOrder = IdSortOrder.none; 
                  });
                  _applyFilterAndSort();
                  Navigator.pop(context); 
                },
              ),
              const Divider(), 
              ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('Hapus Semua Penyortiran'),
                trailing: _currentDateSortOrder == DateSortOrder.none &&
                        _currentIdSortOrder == IdSortOrder.none
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _currentDateSortOrder = DateSortOrder.none;
                    _currentIdSortOrder = IdSortOrder.none;
                  });
                  _applyFilterAndSort();
                  Navigator.pop(context); 
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Jadwal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            )),
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
            onPressed: _navigateToAddJadwalScreen,
            tooltip: 'Tambah Jadwal Baru',
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF1976D2),
              size: 28.0,
            ),
            onPressed: _fetchAndApplyFilterAndSort,
            tooltip: 'Refresh Daftar Jadwal',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _idFilterController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cari berdasarkan ID',
                hintText: 'Masukkan ID jadwal',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: _idFilterController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _idFilterController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: _showSortOptionsBottomSheet,
                  label:
                      const Text('Urutkan & Filter', style: TextStyle(color: Colors.white)),
                  icon: const Icon(Icons.sort, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text('Error: $_errorMessage'))
                    : _displayedJadwals.isEmpty
                        ? const Center(child: Text('Tidak ada jadwal tersedia.'))
                        : ListView.builder(
                            itemCount: _displayedJadwals.length,
                            itemBuilder: (context, index) {
                              final jadwal = _displayedJadwals[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ID: ${jadwal.id ?? "N/A"}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                jadwal.namaBidan ?? 'Nama Bidan Tidak Diketahui',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${jadwal.tanggal?.toLocal().toString().split(' ')[0]} | ${jadwal.startTime} - ${jadwal.endTime}',
                                                style: const TextStyle(color: Colors.white70),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.white),
                                              onPressed: () {
                                                if (jadwal.id != null) {
                                                  _showEditJadwalDialog(jadwal);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'ID Jadwal tidak tersedia untuk diedit.')),
                                                      );
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.white),
                                              onPressed: () {
                                                _confirmDeleteJadwal(context, jadwal);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}