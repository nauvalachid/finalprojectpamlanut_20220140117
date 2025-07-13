// lib/data/model/response/admin/update_admin_profile_response_model.dart
import 'dart:convert';
import 'package:finalproject/data/model/adminprofile_data.dart'; // <--- Import ini

class UpdateAdminProfileResponseModel {
    final String? message;
    final AdminProfileData? data; // <--- Ganti 'Data' menjadi 'AdminProfileData'

    UpdateAdminProfileResponseModel({
        this.message,
        this.data,
    });

    factory UpdateAdminProfileResponseModel.fromJson(String str) => UpdateAdminProfileResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UpdateAdminProfileResponseModel.fromMap(Map<String, dynamic> json) => UpdateAdminProfileResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : AdminProfileData.fromMap(json["data"]), // <--- Gunakan AdminProfileData.fromMap
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}
// HAPUS DEFINISI class Data DI SINI