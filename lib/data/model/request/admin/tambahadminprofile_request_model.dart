import 'dart:io'; // Untuk tipe data File

class AddAdminProfileRequest {
  final String nama;
  final String tanggalLahir; // Biasanya dalam format string seperti 'YYYY-MM-DD'
  final String kelamin;
  final String alamat;
  final String nomorTelepon;
  final File? fotoProfil; // Menggunakan tipe File untuk upload berkas. Nullable jika foto tidak wajib.

  AddAdminProfileRequest({
    required this.nama,
    required this.tanggalLahir,
    required this.kelamin,
    required this.alamat,
    required this.nomorTelepon,
    this.fotoProfil, // Opsional
  });

  /// Mengubah objek ini menjadi Map yang cocok untuk pengiriman 'form-data'.
  /// Catatan: Untuk upload berkas (file), Anda biasanya akan menggunakan
  /// permintaan 'multipart/form-data' dengan paket seperti `http` atau `dio`.
  /// Metode ini menyiapkan bidang-bidang teks.
  Map<String, String> toFormData() {
    return {
      'nama': nama,
      'tanggal_lahir': tanggalLahir,
      'kelamin': kelamin,
      'alamat': alamat,
      'nomor_telepon': nomorTelepon,
      // 'foto_profil' akan ditangani secara terpisah dalam permintaan multipart
    };
  }

  // Jika Anda perlu mengirim dalam format JSON (misalnya, tanpa file),
  // Anda bisa menambahkan metode toJson() seperti ini (tapi untuk kasus ini, toFormData lebih relevan):
  // Map<String, dynamic> toJson() {
  //   return {
  //     'nama': nama,
  //     'tanggal_lahir': tanggalLahir,
  //     'kelamin': kelamin,
  //     'alamat': alamat,
  //     'nomor_telepon': nomorTelepon,
  //     // Untuk JSON, file biasanya dikirim sebagai string base64 atau URL,
  //     // yang kurang umum untuk upload file langsung.
  //     // 'foto_profil': fotoProfil != null ? base64Encode(fotoProfil!.readAsBytesSync()) : null,
  //   };
  // }
}