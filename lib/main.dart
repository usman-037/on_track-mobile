import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ontrack/busesroutes.dart';
import 'package:ontrack/change_password.dart';
import 'package:ontrack/feeslip.dart';
import 'package:ontrack/getEmail.dart';
import 'package:ontrack/guardian_track_route.dart';
import 'package:ontrack/hostelite_home.dart';
import 'package:ontrack/login.dart';
import 'package:ontrack/lostandfound.dart';
import 'package:ontrack/reportanissue.dart';
import 'package:ontrack/requestroutechange.dart';
import 'package:ontrack/requestscreen.dart';
import 'package:ontrack/scanqrcode.dart';
import 'package:ontrack/signup.dart';
import 'package:ontrack/passenger_home.dart';
import 'package:ontrack/generateqrcode.dart';
import 'package:ontrack/splash.dart';
import 'package:ontrack/supervisor_home.dart';
import 'package:ontrack/transportfees.dart';
import 'package:ontrack/verifyEmail.dart';
import 'package:ontrack/edit_profile.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:ontrack/verifyEmailforPassword.dart';
import 'package:ontrack/track_route_driver.dart';
import 'package:ontrack/track_route.dart';
import 'package:ontrack/driver_home.dart';
import 'package:ontrack/requestbusswitching.dart';
import 'package:ontrack/guardian_home.dart';
import 'package:ontrack/viewroutestops.dart';

import 'firebase_options.dart';
import 'firebasemessaging.dart';
import 'localnotification.dart';



void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize local notifications
  await LocalNotificationService.initialize();

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();

  @override
  Future<void> initFM() async {
    await _firebaseMessagingService.grantAppPermission();
    await FirebaseMessagingService.init();
  }


  Widget build(BuildContext context) {
    initFM();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const Mysignup(),
        '/passengerHome': (context) => const PassengerHome(),
        '/generateqrcode': (context) => const GetQrCode(),
        '/splash': (context) => const Splash(),
        '/verifyEmail': (context) => const VerifyEmail(),
        '/editProfile': (context) => const EditProfile(),
        '/requestroutechange': (context) => const RequestRouteChange(),
        '/requestscreen': (context) => const RequestScreen(),
        '/reportanissue': (context) => const Reportanissue(),
        '/getEmail': (context) => const GetEmail(),
        '/verifyEmailForPassword': (context) => const VerifyEmailForPassword(),
        '/changePassword': (context) => const ChangePassword(),
        '/lostandfound': (context) => const LostAndFound(),
        '/hosteliteHome': (context) => const HosteliteHome(),
        '/trackroute': (context) => const TrackRoute(),
        '/trackrouteDriver': (context) => const TrackRouteDriver(),
        '/guardianTrackRoute': (context) => const GuardianTrackRoute(),
        '/driverHome': (context) => const DriverHome(),
        '/busesroutes':(context)=> const BusesRoutes(),
        '/requestbusswitching': (context) => const RequestBusSwitching(),
        '/guardianHome': (context) => const GuardianHome(),
        '/viewroutestops': (context) => const ViewRouteStops(),
        '/feeslip': (context) => FeesSlipScreen(),
        '/supervisorHome': (context) => const SupervisorHome(),
        '/scanqrcode': (context) => ScanQrCode(),
        '/transportfees': (context) => TransportFeeDepositScreen(),
      },
    );
  }
}