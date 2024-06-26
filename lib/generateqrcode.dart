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
    _generateqrcode();

    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text('View QR Code', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF03314B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                  //backgroundColor: Color(0xFFE3E2E2),
                ),
                children: [
                  TextSpan(
                    text: 'Attendance will be updated ',
                  ),
                  TextSpan(
                    text: 'once the QR Code is scanned.',
                    style: TextStyle(
                      color: Colors.blue,  // Highlighted portion color
                      fontWeight: FontWeight.bold,  // Highlighted portion style
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),


            if (qrcodedata.isNotEmpty)
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.5), // shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(3, 6), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: QrImageView(
                    data: qrcodedata,
                    version: QrVersions.auto,
                    size: 250.0,
                  ),
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
