import 'dart:convert';

class MelihatJadwalResponseModel {
    final int? id;
    final String? namaBidan;
    final DateTime? tanggal;
    final String? startTime;
    final String? endTime;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    MelihatJadwalResponseModel({
        this.id,
        this.namaBidan,
        this.tanggal,
        this.startTime,
        this.endTime,
        this.createdAt,
        this.updatedAt,
    });

    factory MelihatJadwalResponseModel.fromJson(String str) => MelihatJadwalResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MelihatJadwalResponseModel.fromMap(Map<String, dynamic> json) => MelihatJadwalResponseModel(
        id: json["id"],
        namaBidan: json["nama_bidan"],
        tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nama_bidan": namaBidan,
        "tanggal": "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
