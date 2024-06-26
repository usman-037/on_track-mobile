import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ontrack/dbHelper/constant.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userName = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['userName'];
    final phoneNo = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['femail'];
    final routeNo = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['routeNo'] as int;





    return WillPopScope(
        onWillPop: () async => false, // Disable back button
    child: Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Color(0xFF03314B),
        centerTitle: true,
      ),
      drawer: Drawer(

        width: MediaQuery.of(context).size.width/1.8,

        backgroundColor: Color(0xFFE3E2E2),
        child: ListView(
          children: [
            ListTile(
              title: Text('About',  style: const TextStyle(fontSize: 20, fontFamily: 'Lato', height: 3.7)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Logout',  style: const TextStyle(fontSize: 20, fontFamily: 'Lato', height: -2)),
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
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
                setState(() {
                  _isLoading = true;
                });
                if (_isLoading == true) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                List<LatLng> latLngList = await MongoDatabase.getLatLngList(phoneNo);

                setState(() {
                  _isLoading = false;
                });
                if (_isLoading == false) {
                  Navigator.pop(context);
                }
                Navigator.pushNamed(context, '/trackrouteDriver',
                    arguments: {'latlngList': latLngList,'routeNo':routeNo});

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
                Navigator.pushNamed(context, '/requestbusswitching',
                    arguments: {'userName': userName, 'routeNo': routeNo});
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
                      'assets/icons/bus.png',
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(height: 5),
                    AutoSizeText(
                      'Request Bus Switching',
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
            left: MediaQuery.of(context).size.width / 25,

            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reportanissue', arguments: {'femail': phoneNo});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE3E2E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width ,
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
    ));
  }
}
