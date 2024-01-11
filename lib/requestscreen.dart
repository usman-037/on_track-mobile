import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  Timer? _timer;
  late String femail;
  //late int currentroute;
  //late String currentstop;
  late String requeststatus;
  late int requestedroute;
  late String requestedstop;
  late String formatRemainingTime;

  void initState() {
    super.initState();

  }



  Widget build(BuildContext context) {

    femail = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['femail'];
    final currentroute = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['route'];
    final currentstop = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['stop'];
    final check = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['check'];
    requestedroute = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['requestedroute'];
    requestedstop = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['requestedstop'];
    requeststatus = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['status'];


    fetchdate().then((value) {
      setState(() {
        formatRemainingTime = value;
      });
    });


    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text('Change Route', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF03314B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            //SizedBox(height: 20),
            Card(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                  'Current Route Info',
                  style: TextStyle(

                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                    textAlign: TextAlign.center,
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Route',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$currentroute',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stop',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$currentstop',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (check==true)
            Card(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Route Info',
                      style: TextStyle(

                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Route',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$requestedroute',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stop',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$requestedstop',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$requeststatus',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Card(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/timer.png',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request Availability',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),

                        Text(
                          _timer == null || _timer!.tick == Duration(days: 14)
                              ? 'No request in process'
                              : '${formatRemainingTime}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 281,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  if(await checkstatus())
                    {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Your request is already pending!'),
                          duration: Duration(seconds: 1),
                        ),
                      );

                    }
                  else {
                    Navigator.pushNamed(context, '/requestroutechange',
                        arguments: {'femail': femail,'currentroute':currentroute,'currentstop':currentstop});
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF03314B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'Change Route',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkstatus() async {
    bool request=await checkrequest();
    if (request) {
      return true;
    }
    else
      {
        return false;
      }
  }

   Future<bool> checkrequest() async{
    var result = await MongoDatabase.checkrouterequest(femail);
    return result;

  }

  Future<String> fetchdate() async {

    bool request = await checkrequest();
    if (request) {
      // Calculate remaining time
      DateTime requestDate = await MongoDatabase.getRequestDate(femail);
      Duration remainingTime = Duration(days: 7) -
          DateTime.now().difference(requestDate);
      // Start timer

      _timer = Timer.periodic(remainingTime, (timer) {
        setState(() {
          // Update remaining time UI
          remainingTime = remainingTime - Duration(seconds: 1);

        });
      });
      int days = remainingTime.inDays;
      int hours = remainingTime.inHours % 24;
      int minutes = remainingTime.inMinutes % 60;
   //   int seconds = remainingTime.inSeconds % 60;

      return '$days days, $hours hours, $minutes minutes';
    }

    else{

      return '0-0-0';
    }



  }


}
