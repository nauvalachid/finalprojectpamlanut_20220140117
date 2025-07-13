import 'dart:convert';
import 'package:finalproject/data/model/adminprofile_data.dart'; 

class TambahAdminProfileResponseModel {
    final String? message;
    final AdminProfileData? data; 

    TambahAdminProfileResponseModel({
        this.message,
        this.data,
    });

    factory TambahAdminProfileResponseModel.fromJson(String str) => TambahAdminProfileResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TambahAdminProfileResponseModel.fromMap(Map<String, dynamic> json) => TambahAdminProfileResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : AdminProfileData.fromMap(json["data"]), 
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}