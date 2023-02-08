// To parse this JSON data, do
//
//     final basic = basicFromJson(jsonString);

import 'dart:convert';

Basic basicFromJson(String str) => Basic.fromJson(json.decode(str));

String basicToJson(Basic data) => json.encode(data.toJson());

class Basic {
  Basic({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  int? code;
  int? status;
  String? message;
  List<Datum>? data;

  factory Basic.fromJson(Map<String, dynamic> json) => Basic(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.tId,
    this.name,
    this.status,
    this.view,
    this.like,
    this.images,
    this.step,
    this.isfav,
  });

  String? tId;
  String? name;
  String? status;
  String? view;
  String? like;
  bool? isfav = false;
  String? images;
  String? step;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    tId: json["t_id"],
    name: json["name"],
    status: json["status"],
    view: json["view"],
    like: json["like"],
    images: json["images"],
    step: json["step"],
    isfav: json["isfav"],
  );

  Map<String, dynamic> toJson() => {
    "t_id": tId,
    "name": name,
    "status": status,
    "view": view,
    "like": like,
    "images": images,
    "step": step,
    "isfav": isfav,
  };
}
