import 'dart:convert';

class MelihatProfilePasienResponseModel {
    final String? message;
    final DataPPasien? data;

    MelihatProfilePasienResponseModel({
        this.message,
        this.data,
    });

    factory MelihatProfilePasienResponseModel.fromJson(String str) => MelihatProfilePasienResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MelihatProfilePasienResponseModel.fromMap(Map<String, dynamic> json) => MelihatProfilePasienResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : DataPPasien.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class DataPPasien {
    final int? id;
    final int? userId;
    final String? nama;
    final DateTime? tanggalLahir;
    final String? kelamin;
    final String? alamat;
    final String? nomorTelepon;
    final String? latitude;
    final String? longitude;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    DataPPasien({
        this.id,
        this.userId,
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

    factory DataPPasien.fromJson(String str) => DataPPasien.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DataPPasien.fromMap(Map<String, dynamic> json) => DataPPasien(
        id: json["id"],
        userId: json["user_id"],
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
        "user_id": userId,
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
