import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:ontrack/MongoDBModel.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final fname = args['fname'];
    final femail = args['femail'];
    final fpassword = args['fpassword'];
    final fRole = args['frole'];
    final fRoute = args['froute'] as int;
    final fStop = args['fstop'];
    final matchCode = args['matchCode'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Email Verification',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF03314B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Enter the 6-digit verification code sent to $femail'),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Verification Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String enteredCode = _codeController.text.trim();

                if (enteredCode == matchCode) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  try {
                    var _id = M.ObjectId();
                    LatLng fstopCoords =
                        await MongoDatabase.getLatLngFromAddress(fStop);
                    double flat = fstopCoords.latitude;
                    double flng = fstopCoords.longitude;
                    String? fcmtoken =
                        await FirebaseMessaging.instance.getToken();
                    print("fcmasaaasa");
                    print(fcmtoken);
                    final data = MongoDbModel(
                      id: _id,
                      name: fname,
                      email: femail,
                      password: fpassword,
                      role: fRole,
                      route: fRoute,
                      stop: fStop,
                      stoplat: flat,
                      stoplng: flng,
                      fcmtoken: fcmtoken,
                      feestatus: "unpaid"
                    );

                    if (await MongoDatabase.updateCapacity(fRoute)) {
                      await MongoDatabase.insert(data);
                      Navigator.pop(context); // Dismiss the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Signup successful!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      Navigator.pushReplacementNamed(
                          context, '/login'); // Navigate to login page
                    } else {
                      Navigator.pop(context); // Dismiss the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No seats available!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      Navigator.pushReplacementNamed(
                          context, '/login'); // Navigate to login page
                    }
                  } catch (e) {
                    print('Error inserting data: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error during signup. Please try again.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    Navigator.pushReplacementNamed(context, '/signup');
                  } finally {
                    Navigator.pop(context); // Dismiss the dialog
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Your verification code does not match!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Color(0xFF03314B),
                padding: EdgeInsets.all(13.0),
              ),
              child: Text(
                'Verify',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
