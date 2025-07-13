import 'dart:convert';

class TambahJadwalResponseModel {
    final String? namaBidan;
    final DateTime? tanggal;
    final String? startTime;
    final String? endTime;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;

    TambahJadwalResponseModel({
        this.namaBidan,
        this.tanggal,
        this.startTime,
        this.endTime,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory TambahJadwalResponseModel.fromJson(String str) => TambahJadwalResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TambahJadwalResponseModel.fromMap(Map<String, dynamic> json) => TambahJadwalResponseModel(
        namaBidan: json["nama_bidan"],
        tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "nama_bidan": namaBidan,
        "tanggal": "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
