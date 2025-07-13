import 'dart:convert';

class MelihatPasienResponseModel {
    final int? id;
    final String? nama;
    final DateTime? tanggalLahir;
    final String? kelamin;
    final String? alamat;
    final String? nomorTelepon;
    final String? latitude;
    final String? longitude;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    MelihatPasienResponseModel({
        this.id,
        this.nama,
        this.tanggalLahir,
        this.kelamin,
        this.alamat,
        this.nomorTelepon,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.updatedAt,
    });

    factory MelihatPasienResponseModel.fromJson(String str) => MelihatPasienResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MelihatPasienResponseModel.fromMap(Map<String, dynamic> json) => MelihatPasienResponseModel(
        id: json["id"],
        nama: json["nama"],
        tanggalLahir: json["tanggal_lahir"] == null ? null : DateTime.parse(json["tanggal_lahir"]),
        kelamin: json["kelamin"],
        alamat: json["alamat"],
        nomorTelepon: json["nomor_telepon"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nama": nama,
        "tanggal_lahir": "${tanggalLahir!.year.toString().padLeft(4, '0')}-${tanggalLahir!.month.toString().padLeft(2, '0')}-${tanggalLahir!.day.toString().padLeft(2, '0')}",
        "kelamin": kelamin,
        "alamat": alamat,
        "nomor_telepon": nomorTelepon,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
