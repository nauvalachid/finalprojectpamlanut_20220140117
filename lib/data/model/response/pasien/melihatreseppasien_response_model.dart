import 'dart:convert';

class LihatResepPasienResponseModel {
    final String? message;
    final List<Datum>? data;

    LihatResepPasienResponseModel({
        this.message,
        this.data,
    });

    factory LihatResepPasienResponseModel.fromJson(String str) => LihatResepPasienResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory LihatResepPasienResponseModel.fromMap(Map<String, dynamic> json) => LihatResepPasienResponseModel(
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Datum {
    final int? id;
    final String? diagnosa;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? patientId;
    final int? pendaftaranId;
    final String? potoObat;
    final String? keteranganObat;
    final Pendaftaran? pendaftaran;

    Datum({
        this.id,
        this.diagnosa,
        this.createdAt,
        this.updatedAt,
        this.patientId,
        this.pendaftaranId,
        this.potoObat,
        this.keteranganObat,
        this.pendaftaran,
    });

    factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        diagnosa: json["diagnosa"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        patientId: json["patient_id"],
        pendaftaranId: json["pendaftaran_id"],
        potoObat: json["poto_obat"],
        keteranganObat: json["keterangan_obat"],
        pendaftaran: json["pendaftaran"] == null ? null : Pendaftaran.fromMap(json["pendaftaran"]),
    );

  get potoObatUrl => null;

    Map<String, dynamic> toMap() => {
        "id": id,
        "diagnosa": diagnosa,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "patient_id": patientId,
        "pendaftaran_id": pendaftaranId,
        "poto_obat": potoObat,
        "keterangan_obat": keteranganObat,
        "pendaftaran": pendaftaran?.toMap(),
    };
}

class Pendaftaran {
    final int? id;
    final int? patientId;
    final int? jadwalId;
    final String? keluhan;
    final int? durasi;
    final DateTime? tanggalPendaftaran;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Pendaftaran({
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

    factory Pendaftaran.fromJson(String str) => Pendaftaran.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Pendaftaran.fromMap(Map<String, dynamic> json) => Pendaftaran(
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
