import 'dart:convert';

class EditPasienRequestModel {
    final String? nama;
    final DateTime? tanggalLahir;
    final String? kelamin;
    final String? alamat;
    final String? nomorTelepon;
    final double? latitude;
    final double? longitude;

    EditPasienRequestModel({
        this.nama,
        this.tanggalLahir,
        this.kelamin,
        this.alamat,
        this.nomorTelepon,
        this.latitude,
        this.longitude,
    });

    factory EditPasienRequestModel.fromJson(String str) => EditPasienRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EditPasienRequestModel.fromMap(Map<String, dynamic> json) => EditPasienRequestModel(
        nama: json["nama"],
        tanggalLahir: json["tanggal_lahir"] == null ? null : DateTime.parse(json["tanggal_lahir"]),
        kelamin: json["kelamin"],
        alamat: json["alamat"],
        nomorTelepon: json["nomor_telepon"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "nama": nama,
        "tanggal_lahir": "${tanggalLahir!.year.toString().padLeft(4, '0')}-${tanggalLahir!.month.toString().padLeft(2, '0')}-${tanggalLahir!.day.toString().padLeft(2, '0')}",
        "kelamin": kelamin,
        "alamat": alamat,
        "nomor_telepon": nomorTelepon,
        "latitude": latitude,
        "longitude": longitude,
    };
}
