import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http; // Untuk http.Client
import 'package:finalproject/data/repository/pasien_profile_repository.dart'; // Sesuaikan path
import 'package:finalproject/presentation/pasien/bloc/profilepasien/profilepasien_bloc.dart'; // Sesuaikan path
import 'package:finalproject/presentation/pasien/bloc/profilepasien/profilepasien_event.dart'; // Sesuaikan path
import 'package:finalproject/presentation/pasien/bloc/profilepasien/profilepasien_state.dart'; // Sesuaikan path
import 'package:finalproject/data/model/request/pasien/tambahprofilepasien_request_model.dart'; // Sesuaikan path
import 'package:finalproject/data/model/request/pasien/editprofilepasien_request_model.dart'; // Sesuaikan path
import 'package:finalproject/data/model/response/pasien/melihatprofilepasien_response_model.dart'; // Sesuaikan path

class PasienProfileScreen extends StatefulWidget {
  final String authToken; // Token JWT dari proses login

  const PasienProfileScreen({Key? key, required this.authToken}) : super(key: key);

  @override
  State<PasienProfileScreen> createState() => _PasienProfileScreenState();
}

class _PasienProfileScreenState extends State<PasienProfileScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _kelaminController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController(); // Menggunakan 'longitude' untuk konsistensi di UI

  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    // Secara otomatis memuat profil saat layar pertama kali dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PasienProfileBloc>().add(GetPasienProfileEvent(widget.authToken));
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tanggalLahirController.dispose();
    _kelaminController.dispose();
    _alamatController.dispose();
    _nomorTeleponController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  /// Fungsi untuk mengisi field input dengan data profil pasien.
  /// Sekarang menggunakan tipe 'DataPPasien?' karena ini adalah tipe data dari MelihatProfilePasienResponseModel yang diperbarui.
  void _populateFields(DataPPasien? data) { // PERUBAHAN DI SINI: Data? menjadi DataPPasien?
    if (data != null) {
      _namaController.text = data.nama ?? '';
      _tanggalLahirController.text = data.tanggalLahir?.toLocal().toString().split(' ')[0] ?? '';
      _kelaminController.text = data.kelamin ?? '';
      _alamatController.text = data.alamat ?? '';
      _nomorTeleponController.text = data.nomorTelepon ?? '';
      _latitudeController.text = data.latitude ?? '';
      _longitudeController.text = data.longitude ?? '';
    } else {
      // Bersihkan field jika tidak ada data
      _namaController.clear();
      _tanggalLahirController.clear();
      _kelaminController.clear();
      _alamatController.clear();
      _nomorTeleponController.clear();
      _latitudeController.clear();
      _longitudeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Profil Pasien'),
      ),
      body: BlocProvider(
        // Menyediakan instance BLoC ke widget tree
        create: (context) => PasienProfileBloc(
          pasienProfileRepository: PasienProfileRepositoryImpl(client: http.Client()),
        ),
        child: BlocConsumer<PasienProfileBloc, PasienProfileState>(
          listener: (context, state) {
            // Mendengarkan perubahan state dan memperbarui UI atau menampilkan pesan
            if (state is PasienProfileLoading) {
              setState(() {
                _statusMessage = 'Memuat...';
              });
            } else if (state is PasienProfileLoaded) {
              setState(() {
                _statusMessage = 'Profil berhasil dimuat!';
              });
              // Menggunakan state.profile.data tanpa operator ?? karena _populateFields sudah menangani null
              _populateFields(state.profile.data); 
            } else if (state is PasienProfileCreated) {
              setState(() {
                _statusMessage = 'Profil berhasil dibuat!';
              });
              // Opsional: Muat ulang profil setelah pembuatan untuk memastikan data terbaru
              context.read<PasienProfileBloc>().add(GetPasienProfileEvent(widget.authToken));
            } else if (state is PasienProfileUpdated) {
              setState(() {
                _statusMessage = 'Profil berhasil diperbarui!';
              });
              // Opsional: Muat ulang profil setelah pembaruan
              context.read<PasienProfileBloc>().add(GetPasienProfileEvent(widget.authToken));
            } else if (state is PasienProfileDeleted) {
              setState(() {
                _statusMessage = state.message;
              });
              _populateFields(null); // Bersihkan field setelah penghapusan
            } else if (state is PasienProfileError) {
              setState(() {
                _statusMessage = 'Error: ${state.message}';
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Field Input
                  TextField(
                    controller: _namaController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _tanggalLahirController,
                    decoration: const InputDecoration(labelText: 'Tanggal Lahir (YYYY-MM-DD)'),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _kelaminController,
                    decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _alamatController,
                    decoration: const InputDecoration(labelText: 'Alamat'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nomorTeleponController,
                    decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _latitudeController,
                    decoration: const InputDecoration(labelText: 'Latitude'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _longitudeController,
                    decoration: const InputDecoration(labelText: 'Longitude'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  // Tombol Aksi
                  ElevatedButton(
                    onPressed: () {
                      // Memicu event untuk mengambil profil
                      context.read<PasienProfileBloc>().add(GetPasienProfileEvent(widget.authToken));
                    },
                    child: const Text('Get Profile'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Memicu event untuk membuat profil
                      final request = TambahProfilePasienRequestModel(
                        nama: _namaController.text,
                        tanggalLahir: DateTime.tryParse(_tanggalLahirController.text),
                        kelamin: _kelaminController.text,
                        alamat: _alamatController.text,
                        nomorTelepon: _nomorTeleponController.text,
                        latitude: _latitudeController.text,
                        longtitude: _longitudeController.text, // Menggunakan 'longtitude' sesuai model Anda
                      );
                      context.read<PasienProfileBloc>().add(CreatePasienProfileEvent(
                        token: widget.authToken,
                        requestModel: request,
                      ));
                    },
                    child: const Text('Create Profile'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Memicu event untuk memperbarui profil
                      final request = EditProfilePasienRequestModel(
                        nama: _namaController.text,
                        tanggalLahir: DateTime.tryParse(_tanggalLahirController.text),
                        kelamin: _kelaminController.text,
                        alamat: _alamatController.text,
                        nomorTelepon: _nomorTeleponController.text,
                        latitude: _latitudeController.text,
                        longtitude: _longitudeController.text, // Menggunakan 'longtitude' sesuai model Anda
                      );
                      context.read<PasienProfileBloc>().add(UpdatePasienProfileEvent(
                        token: widget.authToken,
                        requestModel: request,
                      ));
                    },
                    child: const Text('Update Profile'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Memicu event untuk menghapus profil
                      context.read<PasienProfileBloc>().add(DeletePasienProfileEvent(widget.authToken));
                    },
                    child: const Text('Delete Profile'),
                  ),
                  const SizedBox(height: 20),

                  // Pesan Status
                  if (_statusMessage != null)
                    Text(
                      _statusMessage!,
                      style: TextStyle(
                        color: _statusMessage!.startsWith('Error') ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 10),

                  // Indikator Loading
                  if (state is PasienProfileLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
