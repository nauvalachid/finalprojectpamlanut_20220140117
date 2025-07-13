import 'package:finalproject/data/model/request/admin/tambahpasien_request_model.dart';
import 'package:finalproject/presentation/admin/bloc/pasien/pasien_bloc.dart';
import 'package:finalproject/presentation/admin/bloc/pasien/pasien_event.dart';
import 'package:finalproject/presentation/admin/widget/pendataanpasien/pendataan_pasien_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPasienPage extends StatelessWidget {
  const AddPasienPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pasien Baru',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: PasienFormContent(
          onSave: (request) {
            if (request is TambahPasienRequestModel) {
              context.read<PasienBloc>().add(AddPasienEvent(request));
              Navigator.of(context).pop(); // Kembali setelah menambahkan pasien
            }
          },
        ),
      ),
    );
  }
}