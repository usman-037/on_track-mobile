import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:ontrack/MongoDBModel.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    final fname = (ModalRoute
        .of(context)!
        .settings
        .arguments
    as Map<String, dynamic>)['fname'];
    final femail = (ModalRoute
        .of(context)!
        .settings
        .arguments
    as Map<String, dynamic>)['femail'];
    final fpassword = (ModalRoute
        .of(context)!
        .settings
        .arguments
    as Map<String, dynamic>)['fpassword'];
    final fRole = (ModalRoute
        .of(context)!
        .settings
        .arguments
    as Map<String, dynamic>)['frole'];
    final fRoute = (ModalRoute
        .of(context)!
        .settings
        .arguments
    as Map<String, dynamic>)['froute'] as int;
    final fStop = (ModalRoute
        .of(context)!
        .settings
        .arguments
    as Map<String, dynamic>)['fstop'];
    final matchCode = (ModalRoute
        .of(context)!
        .settings
        .arguments
    as Map<String, dynamic>)['matchCode'];
    final _codeController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
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

                // Compare enteredCode with the code sent to the user
                if (enteredCode == matchCode) {
                  _insertData(fname, femail, fpassword, fRole, fRoute, fStop);
                  print("Data inserted!");
                  Navigator.of(context).pushReplacementNamed('/login');
                } else {
                  print("INSERTION FAILED!");
                  Navigator.of(context).pushReplacementNamed('/signup');
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery
                      .of(context)
                      .size
                      .width, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Color(0xFF03314B),
                  padding: EdgeInsets.all(13.0)),
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

  Future<void> _insertData(String fname, String femail, String fpassword,
      String fRole, int fRoute, String fStop) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(
            child: CircularProgressIndicator(),
          ),
    );

    try {
      var _id = M.ObjectId();
      final data = MongoDbModel(
        id: _id,
        name: fname,
        email: femail,
        password: fpassword,
        role: fRole,
        route: fRoute,
        stop: fStop,
      );

      if (await MongoDatabase.updateCapacity(fRoute)) {
        await MongoDatabase.insert(data);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signup successfully!'),
            duration: Duration(seconds: 1),
          ),
        );

        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No seats available!'),
            duration: Duration(seconds: 1),
          ),
        );
        Navigator.of(context).pushReplacementNamed('/signup');
      }
    } catch (e) {
      print('Error inserting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during signup. Please try again.'),
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.of(context).pushReplacementNamed('/signup');
    } finally {
      Navigator.pop(context); // Dismiss the dialog
    }
  }
}
