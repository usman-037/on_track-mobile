import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GetQrCode extends StatefulWidget {
  const GetQrCode({Key? key}) : super(key: key);

  @override
  _GetQrCodeState createState() => _GetQrCodeState();
}

class _GetQrCodeState extends State<GetQrCode> {
  late String userName;
  late String femail;
  String qrcodedata = '';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userName = arguments['userName'];
    femail = arguments['femail'];

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
        backgroundColor: Color(0xFF2BB45A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Attendance will be updated once the QR Code is generated.',
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 281,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  _generateqrcode();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF2BB45A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'Generate',
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
            SizedBox(height: 20),
            if (qrcodedata.isNotEmpty)
              Container(
                width: 281,
                height: 281,
                child: QrImageView(
                  data: qrcodedata,
                  version: QrVersions.auto,
                  size: 200.0, // Adjust the size as needed
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _generateqrcode() {
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    setState(() {
      qrcodedata = '$femail|$userName|$currentDate';
    });
  }
}
