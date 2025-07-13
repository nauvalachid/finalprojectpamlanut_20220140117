import 'dart:convert';

class EditJadwalRequestModel {
    final String? namaBidan;
    final DateTime? tanggal;
    final String? startTime;
    final String? endTime;

    EditJadwalRequestModel({
        this.namaBidan,
        this.tanggal,
        this.startTime,
        this.endTime,
    });

    factory EditJadwalRequestModel.fromJson(String str) => EditJadwalRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EditJadwalRequestModel.fromMap(Map<String, dynamic> json) => EditJadwalRequestModel(
        namaBidan: json["nama_bidan"],
        tanggal: json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
    );

    Map<String, dynamic> toMap() => {
        "nama_bidan": namaBidan,
        "tanggal": "${tanggal!.year.toString().padLeft(4, '0')}-${tanggal!.month.toString().padLeft(2, '0')}-${tanggal!.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
    };
}
