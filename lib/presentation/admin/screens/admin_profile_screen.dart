import 'package:finalproject/presentation/admin/bloc/profile/profile_admin_bloc.dart';
import 'package:finalproject/presentation/admin/bloc/profile/profile_admin_event.dart';
import 'package:finalproject/presentation/admin/bloc/profile/profile_admin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProfileScreen extends StatefulWidget {
  final int? userId; 

  const AdminProfileScreen({Key? key, this.userId}) : super(key: key); 

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.userId != null) {
        context.read<AdminProfileBloc>().add(GetAdminProfile(widget.userId!));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID Admin tidak ditemukan. Mohon login ulang.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final currentState = context.read<AdminProfileBloc>().state;
              if (currentState is AdminProfileLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigasi ke halaman Edit Profil')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data profil belum dimuat.')),
                );
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<AdminProfileBloc, AdminProfileState>(
        listener: (context, state) {
          if (state is AdminProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AdminProfileAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profil admin ${state.newAdminProfile.nama} berhasil ditambahkan!')),
            );
          } else if (state is AdminProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profil admin ${state.updatedAdminProfile.nama} berhasil diupdate!')),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminProfileLoaded) {
            final adminProfile = state.adminProfile;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: adminProfile.fotoProfil != null
                          ? NetworkImage(adminProfile.fotoProfil!)
                          : null,
                      child: adminProfile.fotoProfil == null
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProfileInfo('Nama', adminProfile.nama ?? 'Tidak Tersedia'),
                  _buildProfileInfo(
                      'Tanggal Lahir',
                      adminProfile.tanggalLahir != null
                          ? adminProfile.tanggalLahir!.toIso8601String().split('T')[0]
                          : 'Tidak Tersedia'),
                  _buildProfileInfo('Jenis Kelamin', adminProfile.kelamin ?? 'Tidak Tersedia'),
                  _buildProfileInfo('Alamat', adminProfile.alamat ?? 'Tidak Tersedia'),
                  _buildProfileInfo('Nomor Telepon', adminProfile.nomorTelepon ?? 'Tidak Tersedia'),
                  _buildProfileInfo('ID Pengguna', adminProfile.userId?.toString() ?? 'Tidak Tersedia'),
                ],
              ),
            );
          } else if (state is AdminProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.userId != null) {
                        context.read<AdminProfileBloc>().add(GetAdminProfile(widget.userId!));
                      }
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Tekan tombol edit atau coba lagi.'));
        },
      ),
    );
  }

  Widget _buildProfileInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}