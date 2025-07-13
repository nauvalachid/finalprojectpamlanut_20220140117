import 'dart:convert';

class TambahProfilePasienResponseModel {
    final String? message;
    final DataPPasien? data;

    TambahProfilePasienResponseModel({
        this.message,
        this.data,
    });

    factory TambahProfilePasienResponseModel.fromJson(String str) => TambahProfilePasienResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TambahProfilePasienResponseModel.fromMap(Map<String, dynamic> json) => TambahProfilePasienResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : DataPPasien.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class DataPPasien {
    final String? nama;
    final DateTime? tanggalLahir;
    final String? kelamin;
    final String? alamat;
    final String? nomorTelepon;
    final String? latitude;
    final int? userId;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;

    DataPPasien({
        this.nama,
        this.tanggalLahir,
        this.kelamin,
        this.alamat,
        this.nomorTelepon,
        this.latitude,
        this.userId,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory DataPPasien.fromJson(String str) => DataPPasien.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DataPPasien.fromMap(Map<String, dynamic> json) => DataPPasien(
        nama: json["nama"],
        tanggalLahir: json["tanggal_lahir"] == null ? null : DateTime.parse(json["tanggal_lahir"]),
        kelamin: json["kelamin"],
        alamat: json["alamat"],
        nomorTelepon: json["nomor_telepon"],
        latitude: json["latitude"],
        userId: json["user_id"],
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
        "user_id": userId,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
