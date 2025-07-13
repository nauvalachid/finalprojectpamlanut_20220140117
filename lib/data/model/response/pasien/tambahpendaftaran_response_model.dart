import 'dart:convert';

class TambahPendaftaranResponseModel {
    final String? message;
    final Data? data;

    TambahPendaftaranResponseModel({
        this.message,
        this.data,
    });

    factory TambahPendaftaranResponseModel.fromJson(String str) => TambahPendaftaranResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TambahPendaftaranResponseModel.fromMap(Map<String, dynamic> json) => TambahPendaftaranResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final int? patientId;
    final int? jadwalId;
    final String? keluhan;
    final int? durasi;
    final DateTime? tanggalPendaftaran;
    final String? status;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;

    Data({
        this.patientId,
        this.jadwalId,
        this.keluhan,
        this.durasi,
        this.tanggalPendaftaran,
        this.status,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        patientId: json["patient_id"],
        jadwalId: json["jadwal_id"],
        keluhan: json["keluhan"],
        durasi: json["durasi"],
        tanggalPendaftaran: json["tanggal_pendaftaran"] == null ? null : DateTime.parse(json["tanggal_pendaftaran"]),
        status: json["status"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "patient_id": patientId,
        "jadwal_id": jadwalId,
        "keluhan": keluhan,
        "durasi": durasi,
        "tanggal_pendaftaran": "${tanggalPendaftaran!.year.toString().padLeft(4, '0')}-${tanggalPendaftaran!.month.toString().padLeft(2, '0')}-${tanggalPendaftaran!.day.toString().padLeft(2, '0')}",
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
