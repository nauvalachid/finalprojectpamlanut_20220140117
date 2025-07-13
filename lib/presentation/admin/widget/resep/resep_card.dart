import 'package:flutter/material.dart';
import 'package:finalproject/data/model/response/pasien/melihatreseppasien_response_model.dart';

class ResepCard extends StatelessWidget {
  final Datum resep;
  final VoidCallback onEdit;
  final VoidCallback onExportPdf; // <<<--- TAMBAH CALLBACK BARU

  const ResepCard({
    Key? key,
    required this.resep,
    required this.onEdit,
    required this.onExportPdf, // <<<--- TAMBAH DI CONSTRUCTOR
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Resep Card: resep.potoObat (URL lengkap dari API): ${resep.potoObat ?? 'URL tidak tersedia'}');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diagnosa: ${resep.diagnosa ?? 'N/A'}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text('Keterangan Obat: ${resep.keteranganObat ?? 'N/A'}'),
            if (resep.potoObat != null && resep.potoObat!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Image.network(
                resep.potoObat!,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('!!! Image Load Error for Resep ID ${resep.id}:');
                  print('   URL attempted: ${resep.potoObat}');
                  print('   Error: $error');
                  if (stackTrace != null) {
                    print('   StackTrace: $stackTrace');
                  }
                  return const Text('Gagal memuat foto obat.');
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ] else ...[
              const SizedBox(height: 8.0),
              const Text('Tidak ada foto obat.'),
            ],
            const SizedBox(height: 16.0), // Spasi sebelum tombol
            Align(
              alignment: Alignment.bottomRight,
              child: Row( // <<<--- Gunakan Row untuk menempatkan tombol bersebelahan
                mainAxisSize: MainAxisSize.min, // Agar Row tidak mengambil lebar penuh
                children: [
                  ElevatedButton(
                    onPressed: onEdit,
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 8.0), // Spasi antara tombol
                  ElevatedButton(
                    onPressed: onExportPdf,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Warna berbeda untuk tombol PDF
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Export PDF'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}