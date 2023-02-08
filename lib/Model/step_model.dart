// To parse this JSON data, do
//
//     final step = stepFromJson(jsonString);

import 'dart:convert';

StepData stepFromJson(String str) => StepData.fromJson(json.decode(str));

String stepToJson(StepData data) => json.encode(data.toJson());

class StepData {
  StepData({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  int? code;
  int? status;
  String? message;
  List<StepDatum>? data;

  factory StepData.fromJson(Map<String, dynamic> json) => StepData(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    data: List<StepDatum>.from(json["data"].map((x) => StepDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class StepDatum {
  StepDatum({
    this.image,
  });

  String? image;

  factory StepDatum.fromJson(Map<String, dynamic> json) => StepDatum(
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
  };
}
