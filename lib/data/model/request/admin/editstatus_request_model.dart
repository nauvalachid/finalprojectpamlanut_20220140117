import 'dart:convert';

class EditStatusRequestModel {
    final String? status;

    EditStatusRequestModel({
        this.status,
    });

    factory EditStatusRequestModel.fromJson(String str) => EditStatusRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EditStatusRequestModel.fromMap(Map<String, dynamic> json) => EditStatusRequestModel(
        status: json["status"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
    };
}
