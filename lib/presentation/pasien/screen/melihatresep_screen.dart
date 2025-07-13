// lib/presentation/pasien/screen/melihatresep_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer'; // Untuk debugging

// Import BLoC, Event, dan State Anda
import 'package:finalproject/presentation/admin/bloc/resep/resep_bloc.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_event.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_state.dart';
import 'package:finalproject/data/model/response/pasien/melihatreseppasien_response_model.dart'; // Model respons resep

class MelihatResepScreen extends StatefulWidget {
  const MelihatResepScreen({super.key});

  @override
  State<MelihatResepScreen> createState() => _MelihatResepScreenState();
}

class _MelihatResepScreenState extends State<MelihatResepScreen> {
  @override
  void initState() {
    super.initState();
    _fetchResepForPasien(); // Panggil metode ini
  }

  Future<void> _fetchResepForPasien() async {
    final prefs = await SharedPreferences.getInstance();
    final int? patientIdDebug = prefs.getInt('patient_id');
    log('MelihatResepScreen: Memuat resep untuk pasien. Patient ID (dari SharedPreferences) untuk debug: $patientIdDebug');

    if (mounted) {
      context.read<ResepBloc>().add(const LoadResepForAuthenticatedPasien());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Resep Medis'),
        backgroundColor: const Color(0xFF2980B9),
      ),
      body: BlocBuilder<ResepBloc, ResepState>(
        builder: (context, state) {
          if (state is ResepLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResepLoadSuccess) {
            final List<Datum> reseps = state.response.data ?? [];
            if (reseps.isEmpty) {
              return const Center(
                child: Text(
                  'Anda belum memiliki riwayat resep medis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: reseps.length,
              itemBuilder: (context, index) {
                final resep = reseps[index];
                return _buildResepCard(context, resep);
              },
            );
          } else if (state is ResepLoadEmpty) {
            return const Center(
              child: Text(
                'Anda belum memiliki riwayat resep medis.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          } else if (state is ResepError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gagal memuat resep: ${state.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            );
          }
          return const Center(
            child: Text(
              'Tekan tombol refresh untuk memuat resep.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResepCard(BuildContext context, Datum resep) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          log('Resep Card Tapped: ${resep.diagnosa}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Diagnosa: ${resep.diagnosa ?? 'Tidak ada diagnosa'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2980B9),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Keterangan Obat: ${resep.keteranganObat ?? 'Tidak ada keterangan'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              // --- Bagian Tampilan Gambar Obat ---
              if (resep.potoObat != null && resep.potoObat!.isNotEmpty)
                Builder( // Menggunakan Builder untuk mendapatkan BuildContext yang valid untuk log
                  builder: (context) {
                    log('Image URL for ${resep.diagnosa}: ${resep.potoObat}'); // Log URL yang akan dimuat
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        resep.potoObat!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          log('Image loading ERROR for ${resep.diagnosa}: $error'); // Log error dari Image.network
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, color: Colors.grey[400], size: 50),
                                const Text(
                                  'Gambar tidak dapat dimuat',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                )
              else
                Builder( // Menggunakan Builder untuk mendapatkan BuildContext yang valid untuk log
                  builder: (context) {
                    log('Image URL for ${resep.diagnosa} is NULL or EMPTY. Displaying placeholder.'); // Log jika URL null/kosong
                    return Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Tidak ada foto obat',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }
                ),
              const SizedBox(height: 12),
              if (resep.pendaftaran != null)
                Text(
                  'Pendaftaran ID: ${resep.pendaftaran!.id}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
