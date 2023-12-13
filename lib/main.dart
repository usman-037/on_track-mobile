import 'package:flutter/material.dart';
import 'package:ontrack/change_password.dart';
import 'package:ontrack/getEmail.dart';
import 'package:ontrack/login.dart';
import 'package:ontrack/lostandfound.dart';
import 'package:ontrack/reportanissue.dart';
import 'package:ontrack/requestroutechange.dart';
import 'package:ontrack/requestscreen.dart';
import 'package:ontrack/signup.dart';
import 'package:ontrack/passenger_home.dart';
import 'package:ontrack/generateqrcode.dart';
import 'package:ontrack/splash.dart';
import 'package:ontrack/verifyEmail.dart';
import 'package:ontrack/edit_profile.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:ontrack/verifyEmailforPassword.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/splash',
    routes: {
      '/login': (context) => const Login(),
      '/signup': (context) => const Mysignup(),
      '/passengerHome': (context) =>  const PassengerHome(),
      '/generateqrcode': (context) => const GetQrCode(),
      '/splash': (context) => const Splash(),
      '/verifyEmail': (context) => const VerifyEmail(),
      '/editProfile':(context)=> const EditProfile(),
      '/requestroutechange':(context)=> const RequestRouteChange(),
      '/requestscreen':(context)=> const RequestScreen(),
      '/reportanissue':(context)=>const Reportanissue(),
      '/getEmail':(context)=>const GetEmail(),
      '/verifyEmailForPassword':(context)=>const VerifyEmailForPassword(),
      '/changePassword':(context)=> const ChangePassword(),
      '/lostandfound':(context)=> lostandfound(),
    },
  ));
}