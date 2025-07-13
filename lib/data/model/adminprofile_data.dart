// lib/data/model/admin_profile_data_model.dart

import 'dart:convert';

class AdminProfileData {
  final int? id; // Ini adalah primary key 'id' dari tabel 'admin'
  final int? userId; // Ini adalah 'user_id' yang merujuk ke tabel 'users'
  final String? nama;
  final DateTime? tanggalLahir;
  final String? kelamin;
  final String? alamat;
  final String? nomorTelepon;
  final String? fotoProfil;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdminProfileData({
    this.id,
    this.userId,
    this.nama,
    this.tanggalLahir,
    this.kelamin,
    this.alamat,
    this.nomorTelepon,
    this.fotoProfil,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminProfileData.fromJson(String str) => AdminProfileData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AdminProfileData.fromMap(Map<String, dynamic> json) => AdminProfileData(
        id: json["id"],
        userId: json["user_id"], // <-- PASTIKAN INI SESUAI DENGAN NAMA KOLOM DI DB ANDA
        nama: json["nama"],
        tanggalLahir: json["tanggal_lahir"] == null ? null : DateTime.parse(json["tanggal_lahir"]),
        kelamin: json["kelamin"],
        alamat: json["alamat"],
        nomorTelepon: json["nomor_telepon"],
        fotoProfil: json["foto_profil"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId, // <-- PASTIKAN INI SESUAI DENGAN NAMA KOLOM DI DB ANDA
        "nama": nama,
        // Penanganan tanggalLahir null:
        "tanggal_lahir": tanggalLahir != null
            ? "${tanggalLahir!.year.toString().padLeft(4, '0')}-${tanggalLahir!.month.toString().padLeft(2, '0')}-${tanggalLahir!.day.toString().padLeft(2, '0')}"
            : null, // Tambahkan ini agar tidak error jika tanggalLahir null
        "kelamin": kelamin,
        "alamat": alamat,
        "nomor_telepon": nomorTelepon,
        "foto_profil": fotoProfil,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminProfileData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          nama == other.nama &&
          tanggalLahir == other.tanggalLahir &&
          kelamin == other.kelamin &&
          alamat == other.alamat &&
          nomorTelepon == other.nomorTelepon &&
          fotoProfil == other.fotoProfil &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      nama.hashCode ^
      tanggalLahir.hashCode ^
      kelamin.hashCode ^
      alamat.hashCode ^
      nomorTelepon.hashCode ^
      fotoProfil.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}