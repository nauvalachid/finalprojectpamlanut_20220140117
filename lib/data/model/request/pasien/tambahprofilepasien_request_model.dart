import 'dart:convert';

class TambahProfilePasienRequestModel {
    final String? nama;
    final DateTime? tanggalLahir;
    final String? kelamin;
    final String? alamat;
    final String? nomorTelepon;
    final String? latitude;
    final String? longtitude;

    TambahProfilePasienRequestModel({
        this.nama,
        this.tanggalLahir,
        this.kelamin,
        this.alamat,
        this.nomorTelepon,
        this.latitude,
        this.longtitude,
    });

    factory TambahProfilePasienRequestModel.fromJson(String str) => TambahProfilePasienRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TambahProfilePasienRequestModel.fromMap(Map<String, dynamic> json) => TambahProfilePasienRequestModel(
        nama: json["nama"],
        tanggalLahir: json["tanggal_lahir"] == null ? null : DateTime.parse(json["tanggal_lahir"]),
        kelamin: json["kelamin"],
        alamat: json["alamat"],
        nomorTelepon: json["nomor_telepon"],
        latitude: json["latitude"],
        longtitude: json["longtitude"],
    );

    Map<String, dynamic> toMap() => {
        "nama": nama,
        "tanggal_lahir": "${tanggalLahir!.year.toString().padLeft(4, '0')}-${tanggalLahir!.month.toString().padLeft(2, '0')}-${tanggalLahir!.day.toString().padLeft(2, '0')}",
        "kelamin": kelamin,
        "alamat": alamat,
        "nomor_telepon": nomorTelepon,
        "latitude": latitude,
        "longtitude": longtitude,
    };
}
