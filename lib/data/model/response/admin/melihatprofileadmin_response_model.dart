import 'dart:convert';
import 'package:finalproject/data/model/adminprofile_data.dart'; 

class MelihatAdminProfileResponseModel {
    final String? message;
    final AdminProfileData? data; 

    MelihatAdminProfileResponseModel({
        this.message,
        this.data,
    });

    factory MelihatAdminProfileResponseModel.fromJson(String str) => MelihatAdminProfileResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MelihatAdminProfileResponseModel.fromMap(Map<String, dynamic> json) => MelihatAdminProfileResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : AdminProfileData.fromMap(json["data"]), 
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}