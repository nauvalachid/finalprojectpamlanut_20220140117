import 'dart:convert';

class EditStatusResponseModel {
    final String? message;
    final Data? data;

    EditStatusResponseModel({
        this.message,
        this.data,
    });

    factory EditStatusResponseModel.fromJson(String str) => EditStatusResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EditStatusResponseModel.fromMap(Map<String, dynamic> json) => EditStatusResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final int? id;
    final int? patientId;
    final int? jadwalId;
    final String? keluhan;
    final int? durasi;
    final DateTime? tanggalPendaftaran;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Data({
        this.id,
        this.patientId,
        this.jadwalId,
        this.keluhan,
        this.durasi,
        this.tanggalPendaftaran,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        patientId: json["patient_id"],
        jadwalId: json["jadwal_id"],
        keluhan: json["keluhan"],
        durasi: json["durasi"],
        tanggalPendaftaran: json["tanggal_pendaftaran"] == null ? null : DateTime.parse(json["tanggal_pendaftaran"]),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "patient_id": patientId,
        "jadwal_id": jadwalId,
        "keluhan": keluhan,
        "durasi": durasi,
        "tanggal_pendaftaran": "${tanggalPendaftaran!.year.toString().padLeft(4, '0')}-${tanggalPendaftaran!.month.toString().padLeft(2, '0')}-${tanggalPendaftaran!.day.toString().padLeft(2, '0')}",
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
