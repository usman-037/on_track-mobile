// To parse this JSON data, do
//
//     final mongoDbModel = mongoDbModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) => MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

class MongoDbModel {
  ObjectId id;
  String name;
  String phonenumber;
  String email;
  String password;
  String role;
  MongoDbModel({
    required this.id,
    required this.name,
    required this.phonenumber,
    required this.email,
    required this.password,
    required this.role,
  });

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
    id: json["_id"],
    name: json["name"],
    phonenumber: json["phonenumber"],
    email: json["email"],
    password: json["password"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "phonenumber": phonenumber,
    "email": email,
    "password": password,
    "role":role,
  };
}
