import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ontrack/dbHelper/constant.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SupervisorHome extends StatefulWidget {
  const SupervisorHome({super.key});

  @override
  State<SupervisorHome> createState() => _SupervisorHomeState();
}

class _SupervisorHomeState extends State<SupervisorHome> {
  @override
  Widget build(BuildContext context) {
    final userName = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['userName'];
    final femail = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['femail'];
    final routeNo = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['routeNo'] as int;

    late String location = ""; //current driver location from google maps

    late int route;
    late int stop;
    late String status;
    late int requestedroute;
    late String requestedstop;
    List<String> routestop = [];
    List<LatLng> latLngList = [];
    Future<void> fetchRouteStops() async {
      List<String> result = await MongoDatabase.queryFetchStops(routeNo);

      setState(() {
        routestop = List.from(result);
      });
    }

    Future<void> getLatLngList() async {
      for (String stopName in routestop) {
        String url =
            'https://maps.googleapis.com/maps/api/geocode/json?address=$stopName&key=$google_api_key';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          if (data['status'] == 'OK') {
            double latitude = data['results'][0]['geometry']['location']['lat'];
            double longitude =
                data['results'][0]['geometry']['location']['lng'];
            LatLng latLng = LatLng(latitude, longitude);
            latLngList.add(latLng);
          } else {
            print('Coordinates not found for $stopName');
          }
        } else {
          throw Exception('Failed to load coordinates');
        }
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Color(0xFF03314B),
        centerTitle: true,
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width / 1.8,
        backgroundColor: Color(0xFFE3E2E2),
        child: ListView(
          children: [
            ListTile(
              title: Text('About',
                  style: const TextStyle(
                      fontSize: 20, fontFamily: 'Lato', height: 3.7)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Logout',
                  style: const TextStyle(
                      fontSize: 20, fontFamily: 'Lato', height: -2)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('isLoggedIn', false);
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(color: Color(0xFF03314B)),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              'Hi, Mr. $userName.',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                height: 0,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(top: 70.0),
            child: Container(
              alignment: Alignment.topCenter,
              child: Text(
                'Your Route: $routeNo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 5,
            left: MediaQuery.of(context).size.width / 25,
            child: ElevatedButton(
              onPressed: () async {
                fetchRouteStops().then((_) async {
                  await getLatLngList();
                });
                Navigator.pushNamed(context, '/trackroute',
                    arguments: {'latlngList': latLngList, 'routeNo': routeNo});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE3E2E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 3.150,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/trackroute.png',
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(height: 15),
                    AutoSizeText(
                      'Track Route',
                      textAlign: TextAlign.center,
                      minFontSize: 14,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 18,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 5,
            right: MediaQuery.of(context).size.width / 25,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scanqrcode');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE3E2E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 3.150,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/qrcode.png',
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(height: 5),
                    AutoSizeText(
                      'Scan QR Code',
                      textAlign: TextAlign.center,
                      minFontSize: 14,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 18,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2.4,
            left: MediaQuery.of(context).size.width / 25,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/lostandfound',
                    arguments: {'userName': userName, 'femail': femail});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE3E2E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 3.150,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/lostfound.png',
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(height: 5),
                    AutoSizeText(
                      'Lost & Found Portal',
                      textAlign: TextAlign.center,
                      minFontSize: 14,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 18,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2.4,
            right: MediaQuery.of(context).size.width / 25,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reportanissue',
                    arguments: {'femail': femail});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE3E2E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 3.150,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/report.png',
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(height: 15),
                    AutoSizeText(
                      'Report Issue',
                      textAlign: TextAlign.center,
                      minFontSize: 14,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 18,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
