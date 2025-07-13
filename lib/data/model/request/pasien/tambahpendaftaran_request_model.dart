import 'dart:convert';

class TambahPendaftaranRequestModel {
    final int? jadwalId;
    final String? keluhan;
    final int? durasi;
    final DateTime? tanggalPendaftaran;
    final String? status;

    TambahPendaftaranRequestModel({
        this.jadwalId,
        this.keluhan,
        this.durasi,
        this.tanggalPendaftaran,
        this.status,
    });

    factory TambahPendaftaranRequestModel.fromJson(String str) => TambahPendaftaranRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TambahPendaftaranRequestModel.fromMap(Map<String, dynamic> json) => TambahPendaftaranRequestModel(
        jadwalId: json["jadwal_id"],
        keluhan: json["keluhan"],
        durasi: json["durasi"],
        tanggalPendaftaran: json["tanggal_pendaftaran"] == null ? null : DateTime.parse(json["tanggal_pendaftaran"]),
        status: json["status"],
    );

    Map<String, dynamic> toMap() => {
        "jadwal_id": jadwalId,
        "keluhan": keluhan,
        "durasi": durasi,
        "tanggal_pendaftaran": "${tanggalPendaftaran!.year.toString().padLeft(4, '0')}-${tanggalPendaftaran!.month.toString().padLeft(2, '0')}-${tanggalPendaftaran!.day.toString().padLeft(2, '0')}",
        "status": status,
    };
}
