import 'dart:io';

class UpdateAdminProfileRequest {
  final String nama;
  final String tanggalLahir;
  final String kelamin;
  final String alamat;
  final String nomorTelepon;
  final File? fotoProfil; 

  UpdateAdminProfileRequest({
    required this.nama,
    required this.tanggalLahir,
    required this.kelamin,
    required this.alamat,
    required this.nomorTelepon,
    this.fotoProfil, 
  });

  Map<String, String> toFormData() {
    return {
      'nama': nama,
      'tanggal_lahir': tanggalLahir,
      'kelamin': kelamin,
      'alamat': alamat,
      'nomor_telepon': nomorTelepon,
      '_method': 'PUT', 
    };
  }
}