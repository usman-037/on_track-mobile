import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
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
    final fname = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['fname'];
    final femail = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['femail'];
    final fpassword = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['fpassword'];
    final fRole = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['frole'];
    final fRoute = (ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>)['froute'] as int;
    final fStop = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['fstop'];
    final _codeController = TextEditingController();
    late String matchCode;
    String _generateRandomCode() {
      // Generate a random 6-digit code
      Random random = Random();
      matchCode = (100000 + random.nextInt(900000)).toString();
      return matchCode;
    }

    Future<void> _sendCode() async {
      final String code = _generateRandomCode();
      try {
        var userEmail = 'ontrackfyp@gmail.com';
        var password = 'rrykntjptdaxaqqa';
        var message = Message();
        message.subject = 'Verification Code for On Track';
        message.text = 'Your verification code is $code';
        message.from = Address(userEmail);
        message.recipients.add(femail);
        var smtpServer = gmail(userEmail, password);
        final sendReport = await send(message, smtpServer);
        print('Email sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Error sending email! $e');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    }

    _sendCode();

    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the 6-digit verification code sent to $femail'),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Verification Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String enteredCode = _codeController.text.trim();
                // Compare enteredCode with the code sent to the user
                if (enteredCode == matchCode) {
                  _insertData(fname, femail, fpassword, fRole, fRoute, fStop);
                  print("Data inserted!");
                  Navigator.of(context).pushReplacementNamed('/login');
                } else {
                  print("INSERTION FAILED!");

                  // Verification failed or email sending failed, navigate back to sign-up screen
                  Navigator.pop(context);

                }
              },
              child: Text('Verify'),
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
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    Navigator.pop(context); // Dismiss the dialog

    var _id = M.ObjectId();
    final data = MongoDbModel(
        id: _id,
        name: fname,
        email: femail,
        password: fpassword,
        role: fRole,
        route: fRoute,
        stop: fStop);
    await MongoDatabase.insert(data);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signup successfully!'),
        duration: Duration(seconds: 1),
      ),
    );
    Navigator.pushNamed(context, '/login');
  }
}
