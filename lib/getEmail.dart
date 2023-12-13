import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:ontrack/MongoDBModel.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class GetEmail extends StatefulWidget {
  const GetEmail({super.key});

  @override
  State<GetEmail> createState() => _GetEmailState();
}

class _GetEmailState extends State<GetEmail> {
  static final TextEditingController emailController = TextEditingController();
  late String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: IconButton(
                  onPressed: () {
                    if (emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fill in all the fields')),
                      );
                    } else
                      _verify(emailController.text);
                  },
                  icon: Icon(Icons.arrow_forward),
                  color: Color(0xFF03314B),
                  iconSize: 48,
                ),
              )
            ])));
  }

  Future<void> _verify(String femail) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (await _sendCode(femail)) {
      Navigator.pushReplacementNamed(context, '/verifyEmailForPassword',
              arguments: {'femail': femail, 'matchCode': code});

    } else {
      Navigator.pop(context); // Dismiss the dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email')),
      );
      emailController.clear();
    }
  }

  String _generateRandomCode() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<bool> _sendCode(String femail) async {
    code = _generateRandomCode();
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
      return true;
    } on MailerException catch (e) {
      print('Error sending email! $e');

      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }
}
