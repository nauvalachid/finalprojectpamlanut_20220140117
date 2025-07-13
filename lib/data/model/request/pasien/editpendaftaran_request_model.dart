import 'dart:convert';

class EditPendaftaranRequestModel {
    final int? jadwalId;
    final String? keluhan;
    final String? durasi;
    final DateTime? tanggalPendaftaran;

    EditPendaftaranRequestModel({
        this.jadwalId,
        this.keluhan,
        this.durasi,
        this.tanggalPendaftaran,
    });

    factory EditPendaftaranRequestModel.fromJson(String str) => EditPendaftaranRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EditPendaftaranRequestModel.fromMap(Map<String, dynamic> json) => EditPendaftaranRequestModel(
        jadwalId: json["jadwal_id"],
        keluhan: json["keluhan"],
        durasi: json["durasi"],
        tanggalPendaftaran: json["tanggal_pendaftaran"] == null ? null : DateTime.parse(json["tanggal_pendaftaran"]),
    );

    Map<String, dynamic> toMap() => {
        "jadwal_id": jadwalId,
        "keluhan": keluhan,
        "durasi": durasi,
        "tanggal_pendaftaran": "${tanggalPendaftaran!.year.toString().padLeft(4, '0')}-${tanggalPendaftaran!.month.toString().padLeft(2, '0')}-${tanggalPendaftaran!.day.toString().padLeft(2, '0')}",
    };
}
