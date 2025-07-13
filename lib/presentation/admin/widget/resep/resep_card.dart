import 'package:flutter/material.dart';
import 'package:finalproject/data/model/response/pasien/melihatreseppasien_response_model.dart';

class ResepCard extends StatelessWidget {
  final Datum resep;
  final VoidCallback onEdit;

  const ResepCard({
    Key? key,
    required this.resep,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Log: Cetak nilai potoObat (sekarang berisi URL lengkap dari API)
    print('Resep Card: resep.potoObat (URL lengkap dari API): ${resep.potoObat ?? 'URL tidak tersedia'}');
    // Log: Baris ini dihapus karena potoObatUrl tidak lagi ada di model
    // print('Resep Card: resep.potoObatUrl (dari API): ${resep.potoObatUrl ?? 'URL tidak tersedia'}');

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
            // Cek apakah potoObat tidak null dan tidak kosong sebelum mencoba memuat gambar
            if (resep.potoObat != null && resep.potoObat!.isNotEmpty) ...[ // <--- PERUBAHAN DI SINI: Gunakan resep.potoObat
              const SizedBox(height: 8.0),
              Image.network(
                resep.potoObat!, // <--- PERUBAHAN DI SINI: Gunakan resep.potoObat
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Log: Cetak error jika Image.network gagal memuat
                  print('!!! Image Load Error for Resep ID ${resep.id}:');
                  print('   URL attempted: ${resep.potoObat}'); // <--- PERUBAHAN DI SINI: Log resep.potoObat
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
                  // Opsional: Tampilkan progress loading
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
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: onEdit,
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
