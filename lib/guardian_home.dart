import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ontrack/dbHelper/constant.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuardianHome extends StatefulWidget {
  const GuardianHome({super.key});

  @override
  State<GuardianHome> createState() => _GuardianHomeState();
}

class _GuardianHomeState extends State<GuardianHome> {
  @override
  Widget build(BuildContext context) {
    final userName = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['userName'];
    final femail = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['femail'];
    final routeNo = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['routeNo'] as int;
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
                            SharedPreferences prefs=await SharedPreferences.getInstance();
                            prefs.setBool('isLoggedIn',false);
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
      body: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          decoration: BoxDecoration(color: Color(0xFF03314B)),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Text(
            'Hi, $userName.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              height: 0,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
            padding: EdgeInsets.only(top: 70.0),
            child: Container(
              alignment: Alignment.topCenter,
              child: Text(
                'Your Child\'s Route: $routeNo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            )),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 1.35,
          right: MediaQuery.of(context).size.width / 50,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/editProfile', arguments: {
                'femail': femail,
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF03314B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 15,
              height: 45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/edit.png',
                    width: 45,
                    height: 45,
                  ),
                  // ),
                ],
              ),
            ),
          ),
        ),

        // BUTTONS
        Positioned(
          top: MediaQuery.of(context).size.height / 5.0,
          left: MediaQuery.of(context).size.width / 19,
          right: MediaQuery.of(context).size.width / 19,
          child: ElevatedButton(
            onPressed: () async {
              fetchRouteStops().then((_) async {
                await getLatLngList();
              });
              Navigator.pushNamed(context, '/guardianTrackRoute',
                  arguments: {'latlngList': latLngList, 'routeNo': routeNo});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE3E2E2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.25,
              height: 137,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/trackroute.png',
                    width: 62,
                    height: 62,
                  ),
                  // ),
                  SizedBox(height: 5),
                  Text(
                    'Track Route',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 19,
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
          top: MediaQuery.of(context).size.height / 2.540,
          left: MediaQuery.of(context).size.width / 19,
          right: MediaQuery.of(context).size.width / 19,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/viewroutestops',
                  arguments: {'userName': userName, 'routeNo': routeNo});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE3E2E2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.25,
              height: 137,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/busstop.png',
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'View Route Stops',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 19,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
