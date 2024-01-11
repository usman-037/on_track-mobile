import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyEmailForPassword extends StatefulWidget {
  const VerifyEmailForPassword({super.key});

  @override
  State<VerifyEmailForPassword> createState() => _VerifyEmailForPasswordState();
}

class _VerifyEmailForPasswordState extends State<VerifyEmailForPassword> {
  @override
  Widget build(BuildContext context) {
    final femail = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['femail'];

    final matchCode = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['matchCode'];
    final _codeController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification',
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

                // Compare enteredCode with the code sent to the user
                if (enteredCode == matchCode) {
                  Navigator.of(context).pushReplacementNamed('/changePassword',
                      arguments: {'femail': femail}).then((_)=>Navigator.pushReplacementNamed(context, '/login'));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Incorrect verification code')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 40),
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
}
