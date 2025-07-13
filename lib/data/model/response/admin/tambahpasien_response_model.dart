import 'dart:convert';

class TambahPasienResponseModel {
    final String? nama;
    final DateTime? tanggalLahir;
    final String? kelamin;
    final String? alamat;
    final String? nomorTelepon;
    final double? latitude;
    final double? longitude;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;

    TambahPasienResponseModel({
        this.nama,
        this.tanggalLahir,
        this.kelamin,
        this.alamat,
        this.nomorTelepon,
        this.latitude,
        this.longitude,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory TambahPasienResponseModel.fromJson(String str) => TambahPasienResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TambahPasienResponseModel.fromMap(Map<String, dynamic> json) => TambahPasienResponseModel(
        nama: json["nama"],
        tanggalLahir: json["tanggal_lahir"] == null ? null : DateTime.parse(json["tanggal_lahir"]),
        kelamin: json["kelamin"],
        alamat: json["alamat"],
        nomorTelepon: json["nomor_telepon"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "nama": nama,
        "tanggal_lahir": "${tanggalLahir!.year.toString().padLeft(4, '0')}-${tanggalLahir!.month.toString().padLeft(2, '0')}-${tanggalLahir!.day.toString().padLeft(2, '0')}",
        "kelamin": kelamin,
        "alamat": alamat,
        "nomor_telepon": nomorTelepon,
        "latitude": latitude,
        "longitude": longitude,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
