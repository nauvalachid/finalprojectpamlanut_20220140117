import 'package:finalproject/presentation/admin/widget/SelamatDatangAdmin_card.dart';
import 'package:finalproject/presentation/admin/widget/app_header.dart';
import 'package:finalproject/presentation/admin/widget/medical_record_card.dart';
import 'package:finalproject/presentation/admin/widget/datapendaftaran_card.dart'; // Ini adalah PendaftaranCard (kartu navigasi)
import 'package:flutter/material.dart';
// Impor Bloc yang tidak lagi diperlukan di sini karena daftar pendaftaran sudah dipindahkan
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:finalproject/bloc/pendaftaran_bloc.dart';
// import 'package:finalproject/data/model/response/melihat_pendaftaran_response_model.dart';


// Fungsi helper untuk dialog detail pendaftaran (tidak lagi diperlukan di sini jika tidak ada daftar detail)
// Jika Anda ingin tetap bisa melihat detail pendaftaran dari AllPendaftaranScreen, biarkan fungsi ini di sana.
// void _showPendaftaranDetailDialog(BuildContext context, MelihatPendaftaranResponseModel pendaftaran) { ... }


class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F2F5),
      child: Stack(
        children: [
          const AppHeader(),

          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const SelamatDatangAdminCard(),
                    const SizedBox(height: 20),
                    const MedicalRecordCard(),
                    const SizedBox(height: 20),
                    const PendaftaranCard(),
                    const SizedBox(height: 80), // Padding bawah untuk BottomNavigationBar
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}