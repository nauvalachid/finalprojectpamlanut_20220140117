import 'package:finalproject/data/model/request/admin/editstatus_request_model.dart';
import 'package:finalproject/data/model/response/admin/melihatpendaftaran_response_model.dart';
import 'package:finalproject/presentation/admin/bloc/pendaftaran/pendaftaran_bloc.dart';
import 'package:finalproject/presentation/admin/screens/resepbypendaftaran_screen.dart'; 
import 'package:finalproject/presentation/admin/widget/resep/tambahresep_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendaftaranItemCard extends StatefulWidget {
  final MelihatPendaftaranResponseModel pendaftaran;
  final VoidCallback? onCardTap;

  const PendaftaranItemCard({
    Key? key, 
    required this.pendaftaran,
    this.onCardTap,
  }) : super(key: key);

  @override
  State<PendaftaranItemCard> createState() => _PendaftaranItemCardState();
}

class _PendaftaranItemCardState extends State<PendaftaranItemCard> {
  late bool _hasResep; 

  @override
  void initState() {
    super.initState();
    _hasResep = widget.pendaftaran.hasResep ?? false;
  }

  @override
  void didUpdateWidget(covariant PendaftaranItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pendaftaran.hasResep != oldWidget.pendaftaran.hasResep) {
      setState(() {
        _hasResep = widget.pendaftaran.hasResep ?? false;
      });
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'diterima':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDisplayText(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return 'PENDING';
      case 'diterima':
        return 'DITERIMA';
      case 'selesai':
        return 'SELESAI';
      case 'ditolak':
        return 'DITOLAK';
      default:
        return 'UNKNOWN';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelesai = widget.pendaftaran.status?.toLowerCase() == 'selesai';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: widget.onCardTap, 
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pendaftaran ID: ${widget.pendaftaran.id ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Keluhan: ${widget.pendaftaran.keluhan ?? 'Tidak ada keluhan'}',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                'Tanggal: ${widget.pendaftaran.tanggalPendaftaran?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.pendaftaran.status),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _getDisplayText(widget.pendaftaran.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (isSelesai) 
                    _hasResep 
                        ? ElevatedButton.icon(
                            onPressed: () {
                              if (widget.pendaftaran.id != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResepByPendaftaranScreen(
                                      pendaftaranId: widget.pendaftaran.id!,
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.visibility),
                            label: const Text('Lihat Resep'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () async {
                              if (widget.pendaftaran.id != null && widget.pendaftaran.patientId != null) {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddResepScreen(
                                      pendaftaranId: widget.pendaftaran.id!,
                                      patientId: widget.pendaftaran.patientId!,
                                    ),
                                  ),
                                );
                                if (result != null && result == true) {
                                  setState(() {
                                    _hasResep = true; 
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('ID Pendaftaran atau Patient ID tidak tersedia.')),
                                );
                              }
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text('Tambah Resep'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal, 
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                  PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (widget.pendaftaran.id != null) {
                        final newStatusRequest = EditStatusRequestModel(status: result);
                        context.read<PendaftaranBloc>().add(
                              EditPendaftaranStatus(widget.pendaftaran.id!, newStatusRequest),
                            );
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'pending',
                        child: Text('Pending'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'diterima',
                        child: Text('Diterima'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'ditolak',
                        child: Text('Ditolak'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'selesai',
                        child: Text('Selesai'),
                      ),
                    ],
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPendaftaranDetailDialog(
    BuildContext context, MelihatPendaftaranResponseModel pendaftaran) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Detail Pendaftaran #${pendaftaran.id ?? ''}'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Patient ID: ${pendaftaran.patientId ?? 'N/A'}'),
              Text('Jadwal ID: ${pendaftaran.jadwalId ?? 'N/A'}'),
              Text('Keluhan: ${pendaftaran.keluhan ?? 'N/A'}'),
              Text('Durasi: ${pendaftaran.durasi ?? 'N/A'} hari'),
              Text(
                  'Tanggal Pendaftaran: ${pendaftaran.tanggalPendaftaran?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
              Text('Status: ${pendaftaran.status?.toUpperCase() ?? 'N/A'}'),
              Text(
                  'Created At: ${pendaftaran.createdAt?.toLocal().toString().split('.')[0] ?? 'N/A'}'),
              Text(
                  'Updated At: ${pendaftaran.updatedAt?.toLocal().toString().split('.')[0] ?? 'N/A'}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Tutup'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}

class AllPendaftaranScreen extends StatefulWidget {
  const AllPendaftaranScreen({super.key});

  @override
  State<AllPendaftaranScreen> createState() => _AllPendaftaranScreenState();
}

class _AllPendaftaranScreenState extends State<AllPendaftaranScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PendaftaranBloc>().add(LoadAllPendaftaran());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Pendaftaran Pasien'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<PendaftaranBloc, PendaftaranState>(
        listener: (context, state) {
          if (state is PendaftaranEdited) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Status pendaftaran berhasil diupdate!')),
            );
            // Refresh daftar setelah update
            context.read<PendaftaranBloc>().add(LoadAllPendaftaran());
          } else if (state is PendaftaranDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pendaftaran ID ${state.id} berhasil dihapus!')),
            );
            context.read<PendaftaranBloc>().add(LoadAllPendaftaran());
          } else if (state is PendaftaranError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: BlocBuilder<PendaftaranBloc, PendaftaranState>(
          builder: (context, state) {
            if (state is PendaftaranLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PendaftaranLoaded) { 
              if (state.pendaftarans.isEmpty) {
                return const Center(
                  child: Text('Belum ada pendaftaran yang tersedia.'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                itemCount: state.pendaftarans.length,
                itemBuilder: (context, index) {
                  final pendaftaran = state.pendaftarans[index];
                  return PendaftaranItemCard(
                    pendaftaran: pendaftaran,
                    onCardTap: () =>
                        _showPendaftaranDetailDialog(context, pendaftaran),
                  );
                },
              );
            } else if (state is PendaftaranError) {
              return Center(
                child: Text('Error memuat pendaftaran: ${state.message}'),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}