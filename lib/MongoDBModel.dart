// To parse this JSON data, do
//
//     final mongoDbModel = mongoDbModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) =>
    MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

class MongoDbModel {
  ObjectId id;
  String name;
  String email;
  String password;
  String role;
  int route;
  String stop;
  MongoDbModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.route,
    required this.stop,
  });

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        route: json["route"],
        stop: json["stop"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "role": role,
        "route": route,
        "stop": stop,
      };
}

reportissueModel reportissueModelFromJson(String str) =>
    reportissueModel.fromJson(json.decode(str));

String reportissueModelToJson(reportissueModel data) =>
    json.encode(data.toJson());

class reportissueModel {
  String email;
  String type;
  String description;
  String status;
  int reportcount;

  reportissueModel({
    required this.email,
    required this.type,
    required this.description,
    required this.status,
    required this.reportcount,
  });

  factory reportissueModel.fromJson(Map<String, dynamic> json) =>
      reportissueModel(
        email: json["email"],
        type: json["type"],
        description: json["description"],
        status: json["status"],
        reportcount: json['reportcount'],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "type": type,
        "description": description,
        "status": status,
        "reportcount": reportcount,
      };
}

routerequestModel routerequestModelFromJson(String str) =>
    routerequestModel.fromJson(json.decode(str));

String routerequestModelToJson(routerequestModel data) =>
    json.encode(data.toJson());

class routerequestModel {
  ObjectId id;
  String email;
  String status;
  int currentroute;
  String currentstop;
  int requestedroute;
  String requestedstop;
  String comments;
  DateTime dateTime;

  routerequestModel({
    required this.id,
    required this.email,
    required this.status,
    required this.currentroute,
    required this.currentstop,
    required this.requestedroute,
    required this.requestedstop,
    required this.comments,
    required this.dateTime,
  });

  factory routerequestModel.fromJson(Map<String, dynamic> json) =>
      routerequestModel(
        id: json["id"],
        email: json["email"],
        status: json["status"],
        currentroute: json["currentroute"],
        currentstop: json["currentstop"],
        requestedroute: json["requestedroute"],
        requestedstop: json["requestedstop"],
        comments: json["comments"],
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "status": status,
        "currentroute": currentroute,
        "currentstop": currentstop,
        "requestedroute": requestedroute,
        "requestedstop": requestedstop,
        "comments": comments,
        "dateTime": dateTime,
      };
}

ReportAndClaimItemModel ReportAndClaimItemModelFromJson(String str) =>
    ReportAndClaimItemModel.fromJson(json.decode(str));
String ReportAndClaimItemModelToJson(routerequestModel data) =>
    json.encode(data.toJson());

class ReportAndClaimItemModel {
  ObjectId id;
  String itemname;
  String routeno;
  String details;
  String imagepath;
  String claimby;

  ReportAndClaimItemModel({
    required this.id,
    required this.itemname,
    required this.routeno,
    required this.details,
    required this.imagepath,
    required this.claimby,
  });

  factory ReportAndClaimItemModel.fromJson(Map<String, dynamic> json) =>
      ReportAndClaimItemModel(
        id: json['id'],
        itemname: json["itemname"],
        routeno: json["routeno"],
        details: json["details"],
        imagepath: json["imagepath"],
        claimby: json["claimby"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        "itemname": itemname,
        "routeno": routeno,
        "details": details,
        "imagepath": imagepath,
        "claimby": claimby,
      };
}
