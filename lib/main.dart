import 'package:flutter/material.dart';
import 'package:ontrack/login.dart';
import 'package:ontrack/signup.dart';
import 'package:ontrack/passenger_home.dart';
import 'package:ontrack/splash.dart';
import 'package:ontrack/dbHelper/mongodb.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/splash',
    routes: {
      '/login': (context) => Login(),
      '/signup': (context) => const Mysignup(),
      '/passengerHome':(context)=> const PassengerHome(),
      '/splash':(context)=>const Splash()

    },
  ));
}