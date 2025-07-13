import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class AppHeader extends StatelessWidget {
  const AppHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('EEE, dd MMM').format(now).toUpperCase();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 40,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/backgroundheader.png'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          colorFilter: ColorFilter.mode(
            Colors.blueAccent.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column( // Column utama untuk seluruh konten header
        crossAxisAlignment: CrossAxisAlignment.start, // Untuk teks rata kiri
        children: [
          Row( // Row untuk ikon notifikasi, tanggal, dan "Butuh Bantuan?"
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Untuk meratakan ke ujung
            crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan secara vertikal
            children: [
              // Kolom untuk tanggal dan "Butuh Bantuan?"
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Pastikan teks rata kiri di dalam kolom ini
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18), // Spasi kecil antara tanggal dan pertanyaan
                  Text(
                    'Klinik Bidan Anik',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Ikon notifikasi (otomatis akan di kanan karena mainAxisAlignment.spaceBetween)
              Icon(
                Icons.notifications_none_outlined,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
          // Jika ada konten lain yang ingin Anda tambahkan di bawah baris ini,
          // tambahkan di sini setelah Row.
        ],
      ),
    );
  }
}