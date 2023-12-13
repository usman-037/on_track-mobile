import 'package:mongo_dart/mongo_dart.dart';
import 'package:ontrack/dbHelper/constant.dart';
import 'package:ontrack/MongoDBModel.dart';
const int maxReportLimit = 3;
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

      return result != null;
    } catch (e) {
      print('Error querying database: $e');
      return false;
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

  static Future<bool> queryEmailandPasswordExists(String femail,
      String fpassword) async {
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

  static Future<bool> queryForgotPassword(
      String femail, String newPassword) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    try {
      var userDocument = await userCollection.findOne(
          await userCollection.update(
              where.eq('email', femail),
              modify.set('password', newPassword)));
      return true;
    } catch (e) {
      print('Error querying database: $e');
      return false; // Re
    } finally {
      await db.close();
    }
    }

  static Future<bool> queryChangePassword(String femail, String fpassword,
      String newPassword) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    try {
      var userDocument = await userCollection.findOne(
          await userCollection.update(
              where.eq('email', femail).and(where.eq('password', fpassword)),
              modify.set('password', newPassword)));
      return true;
    } catch (e) {
      print('Error querying database: $e');
      return false; // Re
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

  static Future<int> queryGetRouteNoFromEmail(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    var result = await userCollection.findOne({
      "email": femail,
    });
    await db.close();
    return result?["route"];
  }

  static Future<bool> updateCapacity(int routeNumber) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTES_COLLECTION);

    var routeDocument =
    await routeCollection.findOne(where.eq('route_no', routeNumber));

    if (routeDocument != null) {
      var currentCapacity = routeDocument['capacity'] ?? 0;
      if (currentCapacity > 0) {
        await routeCollection.update(
          where.eq('route_no', routeNumber),
          modify.set('capacity', currentCapacity - 1),
        );

        print('Capacity updated successfully for route $routeNumber');
        await db.close();
        return true;
      } else {
        print('No available seats for route $routeNumber');
        await db.close();
        return false;
      }
    }
    return false;
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

  static Future<String> insertRequest(routerequestModel data) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTEREQUEST_COLLECTION);
    try {
      var result = await routeCollection.insertOne(data.toJson());
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

  static Future<bool> checkrouterequest(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTEREQUEST_COLLECTION);
    try {
      var result = await routeCollection.findOne(
          where.eq('email', femail).eq('status', 'Unfulfilled'));
      return result != null; // Return true if the email exists, false otherwise
    } catch (e) {
      print('Error querying database: $e');
      return false; // Return false in case of an error
    } finally {
      await db.close();
    }
  }

  static Future<Map<String, dynamic>?> fetchroute(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    try {
      var result = await userCollection.findOne(where.eq('email', femail));
      if (result != null) {
        print('fetching data');
        var route = result['route'] as int?;
        var stop = result['stop'] as String?;
        return {'route': route, 'stop': stop};
      }
      else {
        // Return null if the document is not found
        return null;
      }
    } catch (e) {
      print('Error querying database: $e');
      return null; // Return null in case of an error
    } finally {
      await db.close();
    }
  }

  static getRequestDate(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTEREQUEST_COLLECTION);
    try {
      var result = await routeCollection.findOne(
          where.eq('email', femail).eq('status', 'Unfulfilled'));
      if (result != null) {
        var datetime = result['dateTime'];
        return datetime;
      } // Return true if the email exists, false otherwise
    } catch (e) {
      print('Error querying database: $e');
      return false; // Return false in case of an error
    } finally {
      await db.close();
    }
  }

  static getstatus(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTEREQUEST_COLLECTION);
    try {
      var result = await routeCollection.findOne(
          where.eq('email', femail));
      if (result != null) {
        return result;
      } // Return true if the email exists, false otherwise
    } catch (e) {
      print('Error querying database: $e');
      return false; // Return false in case of an error
    } finally {
      await db.close();
    }
  }

  static Future<String> insertReport(reportissueModel data) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var reportCollection = db.collection(REPORTISSUE_COLLECTION);

    try {
      var result = await reportCollection.insertOne(data.toJson());
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

  static checkroutedata(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTEREQUEST_COLLECTION);
    try {
      var result = await routeCollection.findOne(
          where.eq('email', femail));

      return result != null;
      // Return true if the email exists, false otherwise
    } catch (e) {
      print('Error querying database: $e');
      return false; // Return false in case of an error
    } finally {
      await db.close();
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchUserReportHistory(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var reportCollection = db.collection(REPORTISSUE_COLLECTION);

    try {
      var cursor = reportCollection.find(where.eq('email', femail));
      var documents = await cursor.toList();
      return documents.map((doc) => doc as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error querying database: $e');
      return null;
    } finally {
      await db.close();
    }
  }
  static checkReportLimit(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var reportCollection = db.collection(REPORTISSUE_COLLECTION);

    try {
      var cursor = await reportCollection
          .find(where.eq('email', femail))
          .toList(); // Convert the cursor to a list

      cursor.sort((a, b) => b['reportcount'].compareTo(a['reportcount'])); // Sort in descending order

      var result = cursor.isNotEmpty ? cursor.first : null;
      var reportCount=result?['reportcount'] ?? 0;

      return reportCount < maxReportLimit;
    } catch (e) {
      print('Error checking report limit: $e');
      return false;
    } finally {
      await db.close();
    }
  }
  static checkuserexist(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var reportCollection = db.collection(REPORTISSUE_COLLECTION);

    try {
      var reportDocument = await reportCollection.findOne(where.eq('email', femail));
      return reportDocument==null;
    } catch (e) {
      print('Error checking report limit: $e');
      return false;
    } finally {
      await db.close();
    }
  }
  static fetchcount(String femail) async {


    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var reportCollection = db.collection(REPORTISSUE_COLLECTION);

    try {
      var reportDocument = await reportCollection.findOne(where.eq('email', femail));
      var cursor = await reportCollection
          .find(where.eq('email', femail))
          .toList(); // Convert the cursor to a list

      cursor.sort((a, b) => b['reportcount'].compareTo(a['reportcount'])); // Sort in descending order

      var result = cursor.isNotEmpty ? cursor.first : null;
     var reportcount=result?['reportcount'] ?? 0;
      return reportcount;
    } catch (e) {
      print('Error checking report limit: $e');
      return false;
    } finally {
      await db.close();
    }
  }



    /*static fetchissue(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var reportCollection = db.collection(REPORTISSUE_COLLECTION);
    try {
      var result = await reportCollection.findOne(
          where.eq('email



    if (result != null) {
        return result;
      } // Return true if the email exists, false otherwise
    } catch (e) {
      print('Error querying database: $e');
      return false; // Return false in case of an error
    } finally {
      await db.close();
    }
  }*/


}




