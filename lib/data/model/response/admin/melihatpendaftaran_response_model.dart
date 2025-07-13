import 'dart:convert';

class MelihatPendaftaranResponseModel {
    final int? id;
    final int? patientId;
    final int? jadwalId;
    final String? keluhan;
    final int? durasi;
    final DateTime? tanggalPendaftaran;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    bool? hasResep;

    MelihatPendaftaranResponseModel({
        this.id,
        this.patientId,
        this.jadwalId,
        this.keluhan,
        this.durasi,
        this.tanggalPendaftaran,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.hasResep,
    });

    factory MelihatPendaftaranResponseModel.fromJson(String str) => MelihatPendaftaranResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MelihatPendaftaranResponseModel.fromMap(Map<String, dynamic> json) => MelihatPendaftaranResponseModel(
        id: json["id"],
        patientId: json["patient_id"],
        jadwalId: json["jadwal_id"],
        keluhan: json["keluhan"],
        durasi: json["durasi"],
        tanggalPendaftaran: json["tanggal_pendaftaran"] == null ? null : DateTime.parse(json["tanggal_pendaftaran"]),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        hasResep: json["has_resep"], 
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
         "has_resep": hasResep,
    };
}
