import 'package:flutter/material.dart';

class MedicalRecordCard extends StatelessWidget {
  // Tambahkan properti patientId dan onTap
  final int? patientId; // Patient ID bisa null
  final VoidCallback? onTap; // Callback saat tombol "LIHAT" ditekan

  const MedicalRecordCard({
    Key? key,
    this.patientId, // Terima patientId
    this.onTap,     // Terima onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.assignment, // Contoh ikon clipboard
            color: Colors.blue[700],
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            // Tampilkan ID pasien jika ada
            'Riwayat Pasien ${patientId != null ? ': ${patientId.toString()}' : ''}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Pantau dan kelola riwayat medis pasien.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // Gunakan onTap yang diterima dari luar
              onPressed: onTap ?? () {
                // Fallback jika onTap tidak diberikan
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fungsi LIHAT belum diimplementasikan.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700], // Warna tombol
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'LIHAT',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}