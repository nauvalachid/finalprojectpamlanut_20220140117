import 'dart:convert';

class TambahResepResponseModel {
    final String? message;
    final Data? data;

    TambahResepResponseModel({
        this.message,
        this.data,
    });

    factory TambahResepResponseModel.fromJson(String str) => TambahResepResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TambahResepResponseModel.fromMap(Map<String, dynamic> json) => TambahResepResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final String? patientId;
    final String? potoObat;
    final String? diagnosa;
    final String? pendaftaranId;
    final String? keteranganObat;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;

    Data({
        this.patientId,
        this.potoObat,
        this.diagnosa,
        this.pendaftaranId,
        this.keteranganObat,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        patientId: json["patient_id"],
        potoObat: json["poto_obat"],
        diagnosa: json["diagnosa"],
        pendaftaranId: json["pendaftaran_id"],
        keteranganObat: json["keterangan_obat"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "patient_id": patientId,
        "poto_obat": potoObat,
        "diagnosa": diagnosa,
        "pendaftaran_id": pendaftaranId,
        "keterangan_obat": keteranganObat,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
