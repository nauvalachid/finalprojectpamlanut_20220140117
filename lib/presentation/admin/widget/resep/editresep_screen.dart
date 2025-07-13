import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:finalproject/presentation/admin/bloc/resep/resep_bloc.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_event.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_state.dart';
// PERBAIKAN: Mengacu pada kelas Datum yang sudah ada di melihatreseppasien_response_model.dart
import 'package:finalproject/data/model/response/pasien/melihatreseppasien_response_model.dart'; // Import model untuk Datum

class EditResepScreen extends StatefulWidget {
  final Datum resep; // Menggunakan Datum sebagai tipe

  const EditResepScreen({Key? key, required this.resep}) : super(key: key);

  @override
  State<EditResepScreen> createState() => _EditResepScreenState();
}

class _EditResepScreenState extends State<EditResepScreen> {
  late TextEditingController _diagnosaController;
  late TextEditingController _keteranganObatController;
  File? _fotoObatFile; // Untuk foto baru
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _diagnosaController = TextEditingController(text: widget.resep.diagnosa);
    _keteranganObatController = TextEditingController(text: widget.resep.keteranganObat);
    // Jika ada URL foto lama, Anda bisa menampilkannya, tapi untuk pengeditan
    // kita hanya fokus pada unggahan foto baru.
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _fotoObatFile = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _diagnosaController.dispose();
    _keteranganObatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Resep'),
      ),
      body: BlocListener<ResepBloc, ResepState>(
        listener: (context, state) {
          if (state is ResepEditSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Resep berhasil diedit!')),
            );
            Navigator.of(context).pop(true); // Kembali dan memberi tahu screen sebelumnya untuk refresh
          } else if (state is ResepError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _diagnosaController,
                  decoration: const InputDecoration(
                    labelText: 'Diagnosa',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _keteranganObatController,
                  decoration: const InputDecoration(
                    labelText: 'Keterangan Obat',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16.0),
                // Tampilkan foto obat yang sudah ada jika ada
                if (_fotoObatFile != null)
                  Image.file(
                    _fotoObatFile!,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                else if (widget.resep.potoObat != null && widget.resep.potoObat!.isNotEmpty)
                  Image.network(
                    widget.resep.potoObat!, // Asumsi ini adalah URL yang valid
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text('Gagal memuat foto obat lama.'),
                  )
                else
                  const Text('Belum ada foto obat.'),
                const SizedBox(height: 8.0),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Ganti Foto Obat'),
                ),
                const SizedBox(height: 24.0),
                BlocBuilder<ResepBloc, ResepState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is ResepLoading
                          ? null
                          : () {
                              context.read<ResepBloc>().add(
                                    EditResep(
                                      resepId: widget.resep.id!, // Pastikan ID tidak null
                                      patientId: widget.resep.patientId, // Sudah int?, tidak perlu '!'
                                      diagnosa: _diagnosaController.text,
                                      keteranganObat: _keteranganObatController.text,
                                      pendaftaranId: widget.resep.pendaftaranId, // Sudah int?, tidak perlu '!'
                                      potoObatFile: _fotoObatFile,
                                    ),
                                  );
                            },
                      child: state is ResepLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Simpan Perubahan'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}