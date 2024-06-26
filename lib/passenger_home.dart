import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({super.key});

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userName = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['userName'];
    final femail = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['femail'];
    final routeNo = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['routeNo'] as int;
    late int route;
    late String stop;

    return WillPopScope(
        onWillPop: () async => false, // Disable back button
        child: Scaffold(
          backgroundColor: Color(0xFFF8F8F8),
          appBar: AppBar(
            backgroundColor: Color(0xFF03314B),
            centerTitle: true,
          ),
          drawer: Drawer(
            backgroundColor: Color(0xFFE3E2E2),
            child: ListView(
              children: [
                ListTile(
                  title: Text('About'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  title: Text('Logout'),
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
          body: Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6,
              decoration: BoxDecoration(color: Color(0xFF03314B)),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                'Hi, $userName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Lato',
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
                    'Registered Route: $routeNo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Dela Gothic One',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                )),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 1.33,
              right: MediaQuery.of(context).size.width / 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/editProfile', arguments: {
                    'femail': femail,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF03314B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width / 12,
                  height: 75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/edit.png',
                        width: 60,
                        height: 60,
                      ),
                      // ),
                    ],
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
                  LatLng stopCoords = await MongoDatabase.getCoords(femail);

                  setState(() {
                    _isLoading = false;
                  });
                  if (_isLoading == false) {
                    Navigator.pop(context);
                  }
                  Navigator.pushNamed(context, '/trackroute', arguments: {
                    'stopCoords': stopCoords,
                    'routeNo': routeNo
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE3E2E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.25,
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
                      // ),
                      SizedBox(height: 10),
                      Text(
                        'Track Route',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 19,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
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
                  width:
                      MediaQuery.of(context).size.width * 0.17, // Adjust this
                  height: MediaQuery.of(context).size.height / 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/lostfound.png',
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AutoSizeText(
                        'Lost & Found Portal',
                        textAlign: TextAlign.center,
                        minFontSize: 14,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 17,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Button 2
            Positioned(
              top: MediaQuery.of(context).size.height / 2.4,
              left: MediaQuery.of(context).size.width / 2.82,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/generateqrcode',
                      arguments: {'userName': userName, 'femail': femail});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE3E2E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  width:
                      MediaQuery.of(context).size.width * 0.16, // Adjust this
                  height: MediaQuery.of(context).size.height / 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/qrcode.png',
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(height: 20),
                      AutoSizeText(
                        'View QR Code',
                        textAlign: TextAlign.center,
                        minFontSize: 14,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 17,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Button 3
            // Button 3
            Positioned(
              top: MediaQuery.of(context).size.height / 2.4,
              left: MediaQuery.of(context).size.width / 1.5,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                  var result = await MongoDatabase.fetchroute(femail);
                  if (result != null) {
                    route = result['route'];
                    stop = result['stop'];
                  }
                  var requestedroute = 0;
                  String requestedstop = "";
                  String status = "";

                  MongoDatabase.getstatus(femail).then((resultstatus) {
                    print(resultstatus);
                    print("checking");
                    if (resultstatus != null) {
                      requestedroute = resultstatus['requestedroute'];
                      requestedstop = resultstatus['requestedstop'];
                      status = resultstatus['status'];
                      print(requestedstop);
                      print(requestedroute);
                      print(status);
                    }
                  }).catchError((error) {
                    print("Error occurred: $error");
                  });

                  bool check = await MongoDatabase.checkroutedata(femail);
                  //print(check);
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/requestscreen', arguments: {
                    'femail': femail,
                    'route': route,
                    'stop': stop,
                    'requestedroute': requestedroute,
                    'requestedstop': requestedstop,
                    'status': status,
                    'check': check
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE3E2E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  width:
                      MediaQuery.of(context).size.width * 0.17, // Adjust this
                  height: MediaQuery.of(context).size.height / 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/routechange.png',
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(height: 10),
                      AutoSizeText(
                        'Request Route Change',
                        textAlign: TextAlign.center,
                        minFontSize: 14,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF1E1E1E),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 1.58,
              left: MediaQuery.of(context).size.width / 25,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  // Fetch fee status
                  var feeStatus = await fetchfeestatus(femail);
                  Navigator.pop(context); // Close loading dialog

                  if (feeStatus == 'Paid' || feeStatus == 'paid') {
                    // If fee status is paid, show dialog indicating payment status
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Fee Status'),
                          content: Text('You have already paid the fees.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // If fee status is not paid, navigate to fee status screen
                    Navigator.pushNamed(context, '/transportfees',
                        arguments: {'userName': userName, 'femail': femail,'routeNo':routeNo});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE3E2E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.08,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/fee.png',
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Pay Fees',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 19,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 1.58,
              left: MediaQuery.of(context).size.width / 1.5,
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
                  width: MediaQuery.of(context).size.width / 6,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/report.png',
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Report Issue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 19,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }

  Future<bool> checkrequest(String femail) async {
    var result = await MongoDatabase.checkrouterequest(femail);
    return result;
  }

  Future<String?> fetchfeestatus(String femail) async {
    var result = await MongoDatabase.fetchFeeStatus(femail);
    return result;
  }
}
