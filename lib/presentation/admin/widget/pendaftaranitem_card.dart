// File: lib/presentation/admin/widget/pendaftaranitem_card.dart
import 'package:finalproject/core/constants/colors.dart';
import 'package:finalproject/presentation/admin/screens/resepbypendaftaran_screen.dart';
import 'package:finalproject/presentation/admin/widget/resep/tambahresep_screen.dart';
import 'package:flutter/material.dart';

class PendaftaranListItemCard extends StatefulWidget { // UBAH MENJADI StatefulWidget
  final int pendaftaranId;
  final String patientName;
  final String keluhan;
  final String status;
  // Anda mungkin perlu properti tambahan seperti `hasResep` dari data pendaftaran
  // Jika API Anda menyediakan status apakah resep sudah ada untuk pendaftaran ini
  final bool initialHasResep; // Tambahkan properti ini, atau ambil dari model Pendaftaran

  const PendaftaranListItemCard({
    Key? key,
    required this.pendaftaranId,
    required this.patientName,
    required this.keluhan,
    required this.status,
    this.initialHasResep = false, // Nilai default
  }) : super(key: key);

  @override
  State<PendaftaranListItemCard> createState() => _PendaftaranListItemCardState();
}

class _PendaftaranListItemCardState extends State<PendaftaranListItemCard> {
  late bool _hasResep; // State lokal untuk mengelola apakah resep sudah ada

  @override
  void initState() {
    super.initState();
    _hasResep = widget.initialHasResep;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pendaftaran ID: ${widget.pendaftaranId}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text('Pasien: ${widget.patientName}'),
            Text('Keluhan: ${widget.keluhan}'),
            Text('Status: ${widget.status}'),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // Logika tombol: Jika sudah ada resep, tampilkan 'LIHAT RESEP', jika belum, tampilkan 'TAMBAH RESEP'
                onPressed: () async { // Ubah menjadi async karena Navigator.push akan menunggu hasil
                  if (_hasResep) {
                    // Pergi ke halaman lihat resep
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResepByPendaftaranScreen(pendaftaranId: widget.pendaftaranId),
                      ),
                    );
                  } else {
                    // Pergi ke halaman tambah resep
                    final result = await Navigator.push( // Tunggu hasil dari AddResepScreen
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddResepScreen(
                          pendaftaranId: widget.pendaftaranId,
                          patientId: /* Anda perlu mendapatkan patientId di sini, mungkin dari model pendaftaran */ 0, // Placeholder, ganti dengan patientId yang benar
                        ),
                      ),
                    );

                    // Jika resep berhasil ditambahkan (AddResepScreen mengembalikan true/data)
                    if (result != null && result == true) { // Asumsikan AddResepScreen mengembalikan true jika sukses
                      setState(() {
                        _hasResep = true; // Perbarui state lokal
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasResep ? AppColors.primary : Colors.teal, // Warna berbeda untuk membedakan
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _hasResep ? 'LIHAT RESEP' : 'TAMBAH RESEP', // Teks tombol berubah
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}