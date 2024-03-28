import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TransportFeeSlipScreen extends StatelessWidget {
  final String name;
  final String rollNo;
  final String section;
  final int routeNumber;
  final String transactionid;
  final DateTime transactiondate;
  final GlobalKey _globalKey = GlobalKey();

  TransportFeeSlipScreen({
    required this.name,
    required this.rollNo,
    required this.section,
    required this.routeNumber,
    required this.transactionid,
    required this.transactiondate,
  });

  Future<void> _saveImage() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    await ImageGallerySaver.saveImage(pngBytes, name: 'bus_pass_image');
    Fluttertoast.showToast(msg: "Bus pass image saved successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transport Fee Slip', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF03314B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'OnTrack', // Your app name
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0), // Add spacing
                        Text(
                          'Name: $name',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Roll No: $rollNo',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Section: $section',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Route Number: $routeNumber',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Transaction ID: $transactionid',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Transaction Date: ${DateFormat('yyyy-MM-dd').format(transactiondate)}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 20.0),
                        QrImageView(
                          data: '$name\n$rollNo\n$section\n$routeNumber\n$transactionid\n${DateFormat('yyyy-MM-dd').format(transactiondate)}',
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: 281,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  _saveImage();
                  Navigator.popUntil(context, ModalRoute.withName('/passengerHome'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF03314B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'Save Transport Slip',
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
}
