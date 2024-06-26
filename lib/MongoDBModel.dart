import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  double stoplat;
  double stoplng;
  String? fcmtoken;
  String feestatus;

  MongoDbModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.route,
    required this.stop,
    required this.stoplat,
    required this.stoplng,
    required this.fcmtoken,
    required this.feestatus,
  });

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      password: json["password"],
      role: json["role"],
      route: json["route"],
      stop: json["stop"],
      stoplat: json["stoplat"],
      stoplng: json["stoplng"],
      fcmtoken: json["fcmtoken"],
      feestatus: json["feestatus"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "role": role,
        "route": route,
        "stop": stop,
        "stoplat": stoplat,
        "stoplng": stoplng,
        "fcmtoken": fcmtoken,
        "feestatus": feestatus,
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
  Object id;
  String itemname;
  int routeno;
  String details;
  String base64string;
  String itemstatus;

  ReportAndClaimItemModel({
    required this.id,
    required this.itemname,
    required this.routeno,
    required this.details,
    required this.base64string,
    required this.itemstatus,
  });

  factory ReportAndClaimItemModel.fromJson(Map<String, dynamic> json) =>
      ReportAndClaimItemModel(
        id: json['id'],
        itemname: json["itemname"],
        routeno: json["routeno"],
        details: json["details"],
        base64string: json["base64string"],
        itemstatus: json["itemstatus"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        "itemname": itemname,
        "routeno": routeno,
        "details": details,
        "base64string": base64string,
        "itemstatus": itemstatus,
      };
}

class GuardianModel {
  String name, email, password, studentEmail;

  GuardianModel({
    required this.name,
    required this.email,
    required this.password,
    required this.studentEmail,
  });

  factory GuardianModel.fromJson(Map<String, dynamic> json) => GuardianModel(
        name: json["name"],
        email: json["phoneNo"],
        password: json["password"],
        studentEmail: json["studentEmail"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "role": "Guardian",
        "studentEmail": studentEmail,
      };
}
class PaymentDetails {
  String name,femail,transactionid;

  DateTime transactiondate,traveldate;

  PaymentDetails({
    required this.name,
    required this.femail,
    required this.transactionid,
    required this.transactiondate,
    required this.traveldate,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) =>
      PaymentDetails(
        name: json["name"],
        femail:json["femail"],
        transactionid: json["transactionid"],
        transactiondate: json["transactiondate"],
        traveldate:json["traveldate"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "femail":femail,
    "transactionid":transactionid,
    "transactiondate":transactiondate,
    "traveldate":traveldate,
  };
}
class TransportFeeDetails {
  String name,femail,transactionid;
  int routeno;
  DateTime transactiondate;

  TransportFeeDetails({
    required this.name,
    required this.femail,
    required this.transactionid,
    required this.routeno,
    required this.transactiondate,

  });

  factory TransportFeeDetails.fromJson(Map<String, dynamic> json) =>
      TransportFeeDetails(
        name: json["name"],
        femail: json["femail"],
        transactionid: json["transactionid"],
        routeno: json["routeno"],
        transactiondate: json["transactiondate"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "femail":femail,
    "transactionid":transactionid,
    "routeno":routeno,
    "transactiondate":transactiondate,

  };
}
class Attendance {
  String femail, userName, attendanceStatus, date;
  int routeNo;

  Attendance({
    required this.femail,
    required this.userName,
    required this.routeNo,
    required this.attendanceStatus,
    required this.date,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        femail: json["femail"],
        userName: json["userName"],
        routeNo: json["routeNo"],
        attendanceStatus: json["attendanceStatus"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "femail": femail,
        "userName": userName,
        "routeNo": routeNo,
        "attendanceStatus": attendanceStatus,
        "date": date,
      };
}

class ClaimItemModel {
  ObjectId itemid;
  String itemname;
  int routeno;
  String details;
  String base64string;
  String claimby;

  ClaimItemModel({
    required this.itemid,
    required this.itemname,
    required this.routeno,
    required this.details,
    required this.base64string,
    required this.claimby,
  });

  factory ClaimItemModel.fromJson(Map<String, dynamic> json) => ClaimItemModel(
        itemid: json['itemid'],
        itemname: json["itemname"],
        routeno: json["routeno"],
        details: json["details"],
        base64string: json["base64string"],
        claimby: json["claimby"],
      );

  Map<String, dynamic> toJson() => {
        "itemid": itemid, // Convert ObjectId to String
        "itemname": itemname,
        "routeno": routeno,
        "details": details,
        "base64string": base64string,
        "claimby": claimby,
      };
}
