import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer'; // Untuk debugging

// Import BLoC, Event, dan State Anda
import 'package:finalproject/presentation/pasien/bloc/pasien_profile/pasien_profile_bloc.dart';
import 'package:finalproject/presentation/pasien/bloc/pasien_profile/pasien_profile_event.dart';
import 'package:finalproject/presentation/pasien/bloc/pasien_profile/pasien_profile_state.dart';

// Import model respons dan request
import 'package:finalproject/data/model/response/admin/melihatpasien_response_model.dart';
import 'package:finalproject/data/model/request/admin/editpasien_request_model.dart';
import 'package:finalproject/data/model/request/admin/tambahpasien_request_model.dart';

class PasienProfileScreen extends StatefulWidget {
  const PasienProfileScreen({super.key});

  @override
  State<PasienProfileScreen> createState() => _PasienProfileScreenState();
}

class _PasienProfileScreenState extends State<PasienProfileScreen> {
  // Controllers untuk form edit
  final TextEditingController _namaController = TextEditingController(); // Diubah dari _namaLengkapController
  final TextEditingController _emailController = TextEditingController(); // Tetap ada untuk display, tapi tidak dikirim di request Pasien
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  String? _kelaminSelected; // Diubah dari _jenisKelaminSelected

  @override
  void initState() {
    super.initState();
    // Memuat profil pasien saat layar pertama kali dibuat
    _loadProfile();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _nomorTeleponController.dispose();
    _alamatController.dispose();
    _tanggalLahirController.dispose();
    super.dispose();
  }

  void _loadProfile() {
    log('PasienProfileScreen: Dispatching LoadAuthenticatedPasienProfile event.');
    context.read<PasienProfileBloc>().add(const LoadAuthenticatedPasienProfile());
  }

  // Fungsi untuk menampilkan dialog edit profil
  void _showEditProfileDialog(MelihatPasienResponseModel? currentProfile) {
    // Isi controller dengan data profil saat ini
    _namaController.text = currentProfile?.namaLengkap ?? ''; // Masih mengambil dari namaLengkap untuk display
    _emailController.text = currentProfile?.user?.email ?? ''; // Asumsi ada relasi user di model Pasien
    _nomorTeleponController.text = currentProfile?.nomorTelepon ?? '';
    _alamatController.text = currentProfile?.alamat ?? '';
    _tanggalLahirController.text = currentProfile?.tanggalLahir ?? ''; // Format sesuai kebutuhan
    _kelaminSelected = currentProfile?.jenisKelamin; // Masih mengambil dari jenisKelamin untuk display

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profil Pasien'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _namaController, // Diubah
                  decoration: const InputDecoration(labelText: 'Nama'), // Diubah
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  enabled: false, // Email biasanya tidak diedit melalui profil pasien, tapi melalui user
                ),
                TextField(
                  controller: _nomorTeleponController,
                  decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _alamatController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                  maxLines: 3,
                ),
                TextField(
                  controller: _tanggalLahirController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                    hintText: 'Contoh: 1990-01-01',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                DropdownButtonFormField<String>(
                  value: _kelaminSelected, // Diubah
                  decoration: const InputDecoration(labelText: 'Kelamin'), // Diubah
                  items: <String>['laki-laki', 'perempuan'] // Diubah ke lowercase sesuai Laravel request
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() { // setState di sini untuk update nilai dropdown di dialog
                      _kelaminSelected = newValue; // Diubah
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () {
                // Dispatch event update
                final request = EditPasienRequestModel(
                  nama: _namaController.text, // Diubah dari namaLengkap
                  // email: _emailController.text, // Dihapus karena tidak ada di PasienRequest
                  nomorTelepon: _nomorTeleponController.text,
                  alamat: _alamatController.text,
                  tanggalLahir: _tanggalLahirController.text,
                  kelamin: _kelaminSelected, // Diubah dari jenisKelamin
                );
                context.read<PasienProfileBloc>().add(UpdateAuthenticatedPasienProfile(request: request));
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog buat profil baru
  void _showCreateProfileDialog() {
    // Kosongkan controller untuk form create
    _namaController.clear();
    _emailController.clear();
    _nomorTeleponController.clear();
    _alamatController.clear();
    _tanggalLahirController.clear();
    _kelaminSelected = null; // Diubah

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Buat Profil Pasien Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _namaController, // Diubah
                  decoration: const InputDecoration(labelText: 'Nama'), // Diubah
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  enabled: false, // Email biasanya tidak diinput saat membuat profil pasien, tapi dari user yang login
                ),
                TextField(
                  controller: _nomorTeleponController,
                  decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _alamatController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                  maxLines: 3,
                ),
                TextField(
                  controller: _tanggalLahirController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                    hintText: 'Contoh: 1990-01-01',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                DropdownButtonFormField<String>(
                  value: _kelaminSelected, // Diubah
                  decoration: const InputDecoration(labelText: 'Kelamin'), // Diubah
                  items: <String>['laki-laki', 'perempuan'] // Diubah ke lowercase sesuai Laravel request
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _kelaminSelected = newValue; // Diubah
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Buat'),
              onPressed: () {
                // Dispatch event create
                final request = TambahPasienRequestModel(
                  nama: _namaController.text, // Diubah dari namaLengkap
                  // email: _emailController.text, // Dihapus karena tidak ada di PasienRequest
                  nomorTelepon: _nomorTeleponController.text,
                  alamat: _alamatController.text,
                  tanggalLahir: _tanggalLahirController.text,
                  kelamin: _kelaminSelected, // Diubah dari jenisKelamin
                  // userId: ... // Jika userId perlu dikirim, Anda harus mengambilnya dari SharedPreferences atau Auth Bloc
                );
                context.read<PasienProfileBloc>().add(CreateAuthenticatedPasienProfile(request: request));
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pasien'),
        backgroundColor: const Color(0xFF2980B9),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProfile,
          ),
        ],
      ),
      body: BlocConsumer<PasienProfileBloc, PasienProfileState>(
        listener: (context, state) {
          if (state is PasienProfileLoadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profil berhasil dimuat!')),
            );
          } else if (state is PasienProfileCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Profil berhasil dibuat!')),
            );
            _loadProfile(); // Muat ulang profil setelah berhasil membuat
          } else if (state is PasienProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.response.message ?? 'Profil berhasil diperbarui!')),
            );
            _loadProfile(); // Muat ulang profil setelah berhasil update
          } else if (state is PasienProfileDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Setelah hapus, mungkin arahkan ke layar lain atau tampilkan pesan "profil tidak ada"
            // Untuk demo, kita akan memuat ulang dan akan menampilkan "Profil tidak ditemukan"
            _loadProfile();
          } else if (state is PasienProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is PasienProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PasienProfileLoadSuccess) {
            final profile = state.profile;
            if (profile.id == null) { // Asumsi jika ID null berarti profil tidak ditemukan
              return _buildNoProfileFound(context);
            }
            return _buildProfileDisplay(context, profile);
          } else if (state is PasienProfileError) {
            // Jika error adalah "Profil pasien Anda tidak ditemukan", tawarkan untuk membuat
            if (state.message.contains('Profil pasien Anda tidak ditemukan')) {
              return _buildNoProfileFound(context);
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gagal memuat profil: ${state.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            );
          }
          return const Center(
            child: Text(
              'Tekan tombol refresh untuk memuat profil Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileDisplay(BuildContext context, MelihatPasienResponseModel profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileItem('Nama', profile.namaLengkap ?? 'N/A'), // Label diubah ke 'Nama'
          _buildProfileItem('Email', profile.user?.email ?? 'N/A'), // Asumsi relasi user ada
          _buildProfileItem('Nomor Telepon', profile.nomorTelepon ?? 'N/A'),
          _buildProfileItem('Alamat', profile.alamat ?? 'N/A'),
          _buildProfileItem('Tanggal Lahir', profile.tanggalLahir ?? 'N/A'),
          _buildProfileItem('Kelamin', profile.jenisKelamin ?? 'N/A'), // Label diubah ke 'Kelamin'
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _showEditProfileDialog(profile),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2980B9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Konfirmasi penghapusan
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Hapus Profil'),
                      content: const Text('Apakah Anda yakin ingin menghapus profil Anda?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Batal'),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            context.read<PasienProfileBloc>().add(const DeleteAuthenticatedPasienProfile());
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
              label: const Text('Hapus Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF2980B9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildNoProfileFound(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_off,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Profil pasien Anda belum ditemukan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            const Text(
              'Silakan buat profil Anda untuk melanjutkan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _showCreateProfileDialog,
              icon: const Icon(Icons.person_add),
              label: const Text('Buat Profil Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
