import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ontrack/dbHelper/constant.dart';
import 'package:ontrack/MongoDBModel.dart';
import 'package:http/http.dart' as http;

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

  static Future<String> fetchAccountType(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    try {
      var result = await userCollection.findOne({
        "email": femail,
      });
      return result?["role"];
    } catch (e) {
      print('Error querying database: $e');
      return 'null'; // Return false in case of an error
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
              where.eq('email', femail), modify.set('password', newPassword)));
      return true;
    } catch (e) {
      print('Error querying database: $e');
      return false; // Re
    } finally {
      await db.close();
    }
  }

  static Future<bool> queryChangePassword(
      String femail, String fpassword, String newPassword) async {
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

  static Future<String> querygetStdemail(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    var result = await userCollection.findOne({
      "email": femail,
    });
    await db.close();
    return result?["studentEmail"];
  }

  static Future<LatLng> getLatLngFromAddress(String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$google_api_key');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final location = data['results'][0]['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        return LatLng(lat, lng);
      } else {
        throw Exception('Error from Google Maps API: ${data['status']}');
      }
    } else {
      throw Exception('Failed to fetch location from Google Maps API');
    }
  }
  Future<List<Map<String, dynamic>>> fetchlostitems() async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var reportandclaimCollection =
    db.collection(REPORTANDCLAIMLOSTITEMS_COLLECTION);

    try {
      var cursor = reportandclaimCollection.find();
      var documents = await cursor.toList();
      return documents.map((doc) => doc as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error querying lost items: $e');
      return []; // Return an empty list in case of an error
    } finally {
      await db.close();
    }
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

  static Future<List<int>> queryFetchRoutes() async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTES_COLLECTION);
    var cursor = routeCollection.find({
      "route_no": {r"$exists": true}
    });
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
    var stopsList = stopsString.split(':');
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
      var result = await routeCollection
          .findOne(where.eq('email', femail).eq('status', 'Unfulfilled'));
      print(result);
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
      } else {
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
      var result = await routeCollection
          .findOne(where.eq('email', femail).eq('status', 'Unfulfilled'));
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
      var result = await routeCollection.findOne(where.eq('email', femail));
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
      var result = await routeCollection.findOne(where.eq('email', femail));

      return result != null;
      // Return true if the email exists, false otherwise
    } catch (e) {
      print('Error querying database: $e');
      return false; // Return false in case of an error
    } finally {
      await db.close();
    }
  }

  static Future<List<Map<String, dynamic>>?> fetchUserReportHistory(
      String femail) async {
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

  static checkuserexist(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var reportCollection = db.collection(REPORTISSUE_COLLECTION);

    try {
      var reportDocument =
          await reportCollection.findOne(where.eq('email', femail));
      return reportDocument == null;
    } catch (e) {
      print('Error checking report limit: $e');
      return false;
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

      cursor.sort((a, b) => b['reportcount']
          .compareTo(a['reportcount'])); // Sort in descending order

      var result = cursor.isNotEmpty ? cursor.first : null;
      var reportCount = result?['reportcount'] ?? 0;

      return reportCount < maxReportLimit;
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
      var reportDocument =
          await reportCollection.findOne(where.eq('email', femail));
      var cursor = await reportCollection
          .find(where.eq('email', femail))
          .toList(); // Convert the cursor to a list

      cursor.sort((a, b) => b['reportcount']
          .compareTo(a['reportcount'])); // Sort in descending order

      var result = cursor.isNotEmpty ? cursor.first : null;
      var reportcount = result?['reportcount'] ?? 0;
      return reportcount;
    } catch (e) {
      print('Error checking report limit: $e');
      return false;
    } finally {
      await db.close();
    }
  }


  static Future<String> insertReportAndClaimItem(
      ReportAndClaimItemModel item) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var reportandclaimcollection =
        db.collection(REPORTANDCLAIMLOSTITEMS_COLLECTION);

    try {
      var result = await reportandclaimcollection.insertOne(item.toJson());
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

  static Future<String> claimReportItem(ClaimItemModel item) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var claimcollection = db.collection(CLAIMEDBY_COLLECTION);
    try {
      var result = await claimcollection
          .insertOne(item.toJson() as Map<String, Object?>);
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

  static Future<bool> isItemClaimed(ObjectId itemid, String userEmail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var claimCollection = db.collection(CLAIMEDBY_COLLECTION);
    try {
      var result = await claimCollection
          .findOne(where.eq('itemid', itemid).eq('claimby', userEmail));
      return result != null;
    } catch (e) {
      print('Error checking item claim: $e');
      return false;
    } finally {
      await db.close();
    }
  }

  static Future<bool> insertGuardian(GuardianModel data) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);

    try {
      var result = await userCollection.insertOne(data.toJson());
      return result.isSuccess;
    } catch (e) {
      print('Error inserting guardian: $e');
      return false;
    } finally {
      await db.close();
    }
  }

  static void sendLocationToMongoDB(LocationData location, int? routeNo) async {
    try {
      var db = await Db.create(MONGO_CONN_URL);
      await db.open();

      var collection = db.collection(TRACKING_COLLECTION);

      var filter = where.eq('routeNo', routeNo);

      var update = modify
          .set('latitude', location.latitude)
          .set('longitude', location.longitude)
          .set('timestamp', DateTime.now());

      await collection.update(
        filter,
        update,
        upsert: true,
      );

      await db.close();

      print('Location updated!');
    } catch (e) {
      print('Error sending location data: $e');
    }
  }

  static Future<LocationData?> fetchLocationFromMongoDB(int routeNo) async {
    try {
      var db = await Db.create(MONGO_CONN_URL);
      await db.open();

      var collection = db.collection(TRACKING_COLLECTION);

      var result = await collection.findOne({
        "routeNo": routeNo,
      });
      double lat = result?["latitude"];
      double lng = result?["longitude"];
      Map<String, dynamic> locationMap = {
        'latitude': lat,
        'longitude': lng,
      };
      LocationData locationData = LocationData.fromMap(locationMap);
      await db.close();
      return locationData;

      // return locationData;
    } catch (e) {
      print('Error fetching location data: $e');
      return null; // or throw an exception if needed
    }
  }

  static Future<List<String>> queryFetchArrivalTimes(int routeNumber) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTES_COLLECTION);
    var result = await routeCollection.findOne({
      "route_no": routeNumber,
    });
    await db.close();
    var arrivalTimesString = result?["arrival_time"] as String;
    var arrivalTimesList = arrivalTimesString.split(',');
    arrivalTimesList = arrivalTimesList.map((time) => time.trim()).toList();
    return arrivalTimesList;
  }

  static Future<bool> queryphoneStdmailexists(
      String fphone, String fstdemail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    try {
      var result = await userCollection.findOne({
        "email": fphone,
        "studentEmail": fstdemail,
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

  static Future<String> insertpayment(PaymentDetails data) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var busfeeCollection = db.collection(BUSPASSFEE_COLLECTION);

    try {
      var result = await busfeeCollection.insertOne(data.toJson());
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

  static Future<String> inserttransportpayment(TransportFeeDetails data) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var feeCollection = db.collection(TRANSPORTFEE_COLLECTION);

    try {
      var result = await feeCollection.insertOne(data.toJson());
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

  static Future<bool> insertAttendance(Attendance data) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var attendanceCollection = db.collection(ATTENDANCE_COLLECTION);

    try {
      var result = await attendanceCollection.insertOne(data.toJson());
      return result.isSuccess;
    } catch (e) {
      print('Error inserting attendance data: $e');
      return false;
    } finally {
      await db.close();
    }
  }

  static Future<String?> fetchFeeStatus(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);

    try {
      var result = await userCollection.findOne(where.eq('email', femail));
      if (result != null) {
        var feeStatus = result['fee_status'];
        return feeStatus;
      } else {
        // Handle case when user document is not found
        return null;
      }
    } catch (e) {
      print('Error querying database: $e');
      return null;
    } finally {
      await db.close();
    }
  }

  static Future<void> updateFeeStatus(String femail, String status) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);

    try {
      await userCollection.update(
        where.eq('email', femail),
        modify.set('fee_status', status),
      );
    } catch (e) {
      print('Error updating fee status: $e');
    } finally {
      await db.close();
    }
  }

  //Rabia's -------------------------------------------------------------------------
  static Future<List<int>> queryFetchRouteCapacity(int routeNumber) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTES_COLLECTION);
    var cursor = routeCollection.find({"route_no": routeNumber});
    var documents = await cursor.toList();
    var routeCapacities =
        documents.map((doc) => doc["capacity"] as int).toList();
    await db.close();
    return routeCapacities;
  }

  static Future<List<int>> queryFetchLiveRoutes() async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var livetrackCollection = db.collection(TRACKING_COLLECTION);
    var cursor = livetrackCollection.find({
      "routeNo": {r"$exists": true}
    });
    var documents = await cursor.toList();
    var routeNumbers = documents.map((doc) => doc["routeNo"] as int).toList();
    // routeNumbers.forEach((routeNo) {
    //   print(routeNo);
    // });
    await db.close();
    return routeNumbers;
  }

  static Future<List<Map<String, dynamic>>> queryFetchLiveTrackCoordinates(
      int routeNo) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var livetrackCollection = db.collection(TRACKING_COLLECTION);
    var cursor = livetrackCollection.find({"routeNo": routeNo});
    var documents = await cursor.toList();
    var coordinates = documents
        .map((doc) => {
              "longitude": doc["longitude"] as double,
              "latitude": doc["latitude"] as double,
            })
        .toList();
    await db.close();
    return coordinates;
  }

  static Future<LatLng> getCoords(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    var result = await userCollection.findOne({"email": femail});
    await db.close();

    if (result != null &&
        result["stoplat"] != null &&
        result["stoplng"] != null) {
      double stoplat = result["stoplat"];
      double stoplng = result["stoplng"];
      return LatLng(stoplat, stoplng);
    } else {
      throw Exception('Stop coordinates not found for the given email');
    }
  }

  static Future<List<LatLng>> getLatLngList(String femail) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var userCollection = db.collection(USER_COLLECTION);
    var result = await userCollection.findOne({"email": femail});

    if (result != null && result["role"] == "Driver") {
      var routeNo = result["route"]; // Assuming the route number is stored under the key 'route'
      var routesCollection = db.collection(ROUTES_COLLECTION);
      var routeData = await routesCollection.findOne({"route_no": routeNo});

      if (routeData != null) {
        List<double> latitudes = List<double>.from(routeData["latitude"]);
        List<double> longitudes = List<double>.from(routeData["longitude"]);

        List<LatLng> latLngList = [];
        for (int i = 0; i < latitudes.length; i++) {
          latLngList.add(LatLng(latitudes[i], longitudes[i]));
        }

        await db.close();
        return latLngList;
      } else {
        await db.close();
        throw Exception("Route not found");
      }
    } else {
      await db.close();
      throw Exception("Error querying the database");
    }
  }
  static Future<Map<int, List<String>>> queryFetchAllRoutes() async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    var routeCollection = db.collection(ROUTES_COLLECTION);
    var routesCursor = await routeCollection.find();

    Map<int, List<String>> allRoutes = {};

    await for (var route in routesCursor) {
      int routeNumber = route["route_no"] as int;
      var stopsString = route["stops"] as String;
      var stopsList = stopsString.split(':').map((stop) => stop.trim()).toList();
      allRoutes[routeNumber] = stopsList;
    }
    await db.close();

    return allRoutes;
  }

}
