import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) => MongoDbModel.fromJson(json.decode(str));

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
    "role":role,
    "route":route,
    "stop":stop,
  };
}
