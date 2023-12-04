import 'dart:ffi';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:ontrack/dbHelper/constant.dart';
import 'package:ontrack/MongoDBModel.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
  }

  static Future<bool> queryEmailExists(String email) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    try {
      var result = await userCollection.findOne(where.eq('email', email));

      return result != null; // Return true if the email exists, false otherwise
    } catch (e) {
      print('Error querying database: $e');
      return false; // Return false in case of an error
    } finally {
      await db.close();
    }
  }

  static Future<String> insert(MongoDbModel data) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);

    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something went wrong";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    } finally {
      await db.close();
    }
  }

  static Future<bool> queryEmailandPasswordExists(
      String femail, String fpassword) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    try {
      var result = await userCollection.findOne({
        "email": femail,
        "password": fpassword,
      });
      return result !=
          null; // Return true if the email or password exists, false otherwise
    } catch (e) {
      print('Error querying database: $e');
      return false; // Return false in case of an error
    } finally {
      await db.close();
    }
  }

  static Future<String> queryGetUsernameFromEmail(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    var result = await userCollection.findOne({
      "email": femail,
    });
    await db.close();
    return result?["name"];
  }

  static Future<List<int>> queryFetchRoutes() async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTES_COLLECTION);
    var cursor = routeCollection.find({"route_no": {r"$exists": true}});
    var documents = await cursor.toList();
    var routeNumbers = documents.map((doc) => doc["route_no"] as int).toList();
    // routeNumbers.forEach((routeNo) {
    //   print(routeNo);
    // });
    await db.close();
    return routeNumbers;
  }

  static Future<List<String>> queryFetchStops(int routeNumber) async {

    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTES_COLLECTION);
    var result = await routeCollection.findOne({
      "route_no": routeNumber,
    });
    await db.close();
      var stopsString = result?["stops"] as String;
      var stopsList = stopsString.split(',');
      stopsList = stopsList.map((stop) => stop.trim()).toList();
      return stopsList;
  }
}
