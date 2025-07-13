import 'dart:convert';

class EditResepResponseModel {
    final String? message;
    final Data? data;

    EditResepResponseModel({
        this.message,
        this.data,
    });

    factory EditResepResponseModel.fromJson(String str) => EditResepResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EditResepResponseModel.fromMap(Map<String, dynamic> json) => EditResepResponseModel(
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
    final String? diagnosa;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? patientId;
    final String? pendaftaranId;
    final String? potoObat;
    final String? keteranganObat;

    Data({
        this.id,
        this.diagnosa,
        this.createdAt,
        this.updatedAt,
        this.patientId,
        this.pendaftaranId,
        this.potoObat,
        this.keteranganObat,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        diagnosa: json["diagnosa"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        patientId: json["patient_id"],
        pendaftaranId: json["pendaftaran_id"],
        potoObat: json["poto_obat"],
        keteranganObat: json["keterangan_obat"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "diagnosa": diagnosa,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "patient_id": patientId,
        "pendaftaran_id": pendaftaranId,
        "poto_obat": potoObat,
        "keterangan_obat": keteranganObat,
    };
}
