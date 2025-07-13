import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:finalproject/presentation/admin/bloc/resep/resep_bloc.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_event.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_state.dart';
// import 'package:finalproject/presentation/admin/screens/lihatreseppasien_screen.dart'; // Hapus atau biarkan jika tidak mengganggu, tapi tidak digunakan untuk navigasi langsung dari sini lagi

class AddResepScreen extends StatefulWidget {
  final int patientId;
  final int pendaftaranId;

  const AddResepScreen({
    Key? key,
    required this.patientId,
    required this.pendaftaranId,
  }) : super(key: key);

  @override
  State<AddResepScreen> createState() => _AddResepScreenState();
}

class _AddResepScreenState extends State<AddResepScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosaController = TextEditingController();
  final _keteranganObatController = TextEditingController();
  File? _potoObatFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    print('DEBUG: AddResepScreen - initState dipanggil.');
    print(
        'DEBUG: AddResepScreen - patientId: ${widget.patientId}, pendaftaranId: ${widget.pendaftaranId}');
  }

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    print('DEBUG: _showImageSourceActionSheet dipanggil.');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  print('DEBUG: Pengguna memilih Ambil dari Kamera.');
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  print('DEBUG: Pengguna memilih Pilih dari Galeri.');
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    print('DEBUG: _pickImage dipanggil dengan sumber: ${source.toString()}');
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _potoObatFile = File(pickedFile.path);
          print(
              'DEBUG: Foto berhasil dipilih. Path: ${_potoObatFile!.path}, Ukuran: ${_potoObatFile!.lengthSync()} bytes');
        });
      } else {
        print('DEBUG: Pemilihan foto dibatalkan atau tidak ada foto yang dipilih.');
      }
    } catch (e) {
      print('ERROR: Terjadi kesalahan saat memilih gambar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih foto: $e')),
      );
    }
  }

  @override
  void dispose() {
    _diagnosaController.dispose();
    _keteranganObatController.dispose();
    print('DEBUG: AddResepScreen dispose dipanggil.');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: AddResepScreen build dipanggil.');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Resep Baru'),
      ),
      body: BlocListener<ResepBloc, ResepState>(
        listener: (context, state) {
          print('DEBUG: BlocListener menerima state: ${state.runtimeType}');
          if (state is ResepAddSuccess) {
            print('DEBUG: ResepAddSuccess - Resep berhasil ditambahkan. Data: ${state.response}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Resep berhasil ditambahkan!')),
            );
            Future.delayed(const Duration(seconds: 1), () {
              // Langsung pop dengan hasil 'true'
              Navigator.of(context).pop(true);
              print('DEBUG: Pop dari AddResepScreen dengan hasil true.');
            });
          } else if (state is ResepError) {
            print('ERROR: ResepError - Pesan: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is ResepLoading) {
            print('DEBUG: ResepLoading state - Sedang memproses penambahan resep...');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _diagnosaController,
                    decoration: const InputDecoration(
                      labelText: 'Diagnosa',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        print('VALIDATION: Diagnosa kosong.');
                        return 'Diagnosa tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _keteranganObatController,
                    decoration: const InputDecoration(
                      labelText: 'Keterangan Obat',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        print('VALIDATION: Keterangan Obat kosong.');
                        return 'Keterangan Obat tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _potoObatFile != null
                      ? Column(
                          children: [
                            Image.file(
                              _potoObatFile!,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                                'Ukuran file: (${(_potoObatFile!.lengthSync() / 1024).toStringAsFixed(2)} KB)'),
                          ],
                        )
                      : const Text('Belum ada foto obat yang dipilih.',
                          textAlign: TextAlign.center),
                  const SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      print('DEBUG: Tombol "Pilih Foto Obat" ditekan.');
                      _showImageSourceActionSheet(context);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Pilih Foto Obat'),
                  ),
                  const SizedBox(height: 24.0),
                  if (_potoObatFile == null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Foto Obat wajib diisi.',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  BlocBuilder<ResepBloc, ResepState>(
                    builder: (context, state) {
                      print(
                          'DEBUG: BlocBuilder merender ulang. Current state: ${state.runtimeType}');
                      return ElevatedButton(
                        onPressed: state is ResepLoading
                            ? null
                            : () {
                                print('DEBUG: Tombol "Tambah Resep" ditekan.');
                                if (_formKey.currentState!.validate() &&
                                    _potoObatFile != null) {
                                  print(
                                      'DEBUG: Form valid dan foto obat ada, mengirim data resep.');
                                  print('DEBUG: Patient ID: ${widget.patientId}');
                                  print(
                                      'DEBUG: Pendaftaran ID: ${widget.pendaftaranId}');
                                  print('DEBUG: Diagnosa: ${_diagnosaController.text}');
                                  print(
                                      'DEBUG: Keterangan Obat: ${_keteranganObatController.text}');
                                  print(
                                      'DEBUG: Foto Obat File path: ${_potoObatFile?.path ?? "null"}');

                                  context.read<ResepBloc>().add(
                                        AddResep(
                                          patientId: widget.patientId,
                                          diagnosa: _diagnosaController.text,
                                          pendaftaranId: widget.pendaftaranId,
                                          keteranganObat:
                                              _keteranganObatController.text,
                                          potoObatFile: _potoObatFile!,
                                        ),
                                      );
                                } else {
                                  print(
                                      'DEBUG: Form tidak valid atau foto obat belum dipilih. Tidak mengirim data.');
                                  String errorMessage =
                                      'Harap lengkapi semua field yang wajib diisi.';
                                  if (_potoObatFile == null) {
                                    errorMessage += '\nFoto Obat wajib diisi.';
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(errorMessage)),
                                  );
                                }
                              },
                        child: state is ResepLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Tambah Resep'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}