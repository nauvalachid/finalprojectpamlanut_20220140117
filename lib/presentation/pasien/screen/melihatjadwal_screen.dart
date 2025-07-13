import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal yang lebih baik

// Import JadwalBloc dan JadwalState Anda
import 'package:finalproject/presentation/admin/bloc/jadwal/jadwal_bloc.dart';
import 'package:finalproject/presentation/admin/bloc/jadwal/jadwal_event.dart';
import 'package:finalproject/presentation/admin/bloc/jadwal/jadwal_state.dart';


class MelihatJadwalPasienScreen extends StatefulWidget {
  const MelihatJadwalPasienScreen({super.key});

  @override
  State<MelihatJadwalPasienScreen> createState() => _MelihatJadwalPasienScreenState();
}

class _MelihatJadwalPasienScreenState extends State<MelihatJadwalPasienScreen> {
  @override
  void initState() {
    super.initState();
    // Meminta JadwalBloc untuk memuat jadwal saat screen ini dibuka
    // Pastikan JadwalBloc sudah tersedia di atas widget tree (di main.dart)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JadwalBloc>().add(const LoadJadwals());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dihilangkan dari sini karena sudah ditangani di PasienHomeScreen
      // appBar: AppBar(
      //   title: const Text('Jadwal Konsultasi Tersedia'),
      //   backgroundColor: Colors.blueAccent,
      //   foregroundColor: Colors.white,
      // ),
      body: BlocConsumer<JadwalBloc, JadwalState>(
        listener: (context, state) {
          if (state is JadwalError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error memuat jadwal: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is JadwalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JadwalLoaded) {
            if (state.jadwals.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada jadwal konsultasi yang tersedia saat ini.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Silakan cek kembali nanti atau hubungi Admin.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.jadwals.length,
              itemBuilder: (context, index) {
                final jadwal = state.jadwals[index];
                // Format tanggal agar lebih mudah dibaca
                final String formattedDate = jadwal.tanggal != null
                    ? DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(jadwal.tanggal!) // 'id_ID' untuk bahasa Indonesia
                    : 'Tanggal Tidak Diketahui';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bidan: ${jadwal.namaBidan ?? 'Tidak Diketahui'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Tanggal: $formattedDate',
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Waktu: ${jadwal.startTime ?? 'N/A'} - ${jadwal.endTime ?? 'N/A'}',
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is JadwalInitial) {
            return const Center(child: Text('Memuat jadwal...'));
          }
          return const Center(child: Text('Terjadi kesalahan yang tidak diketahui.'));
        },
      ),
    );
  }
}