import 'package:finalproject/presentation/admin/widget/medical_record_card.dart';
import 'package:flutter/material.dart';

class MedicalRecordScreen extends StatelessWidget {
  final int? patientId;

  const MedicalRecordScreen({Key? key, this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Medis Pasien'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MedicalRecordCard(
                patientId: patientId,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Memuat rekam medis untuk pasien ID: ${patientId ?? 'Tidak Diketahui'}'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}