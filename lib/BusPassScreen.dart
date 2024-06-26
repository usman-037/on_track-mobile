import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BusPassScreen extends StatelessWidget {
  final String name;
  final String femail;
  final int routeNumber;
  final DateTime travelDate;
  final String transactionid;
  final GlobalKey _globalKey = GlobalKey();

  BusPassScreen({
    required this.name,
   required this.femail,
    required this.routeNumber,
    required this.travelDate,
    required this.transactionid,
  });

  Future<void> _saveImage() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    await ImageGallerySaver.saveImage(pngBytes, name: 'bus_pass_image');
    void showSnackBar(BuildContext context) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bus Pass Image saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transport Fee Slip'),
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
                    padding: const EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'OnTrack', // Your app name
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0), // Add spacing
                        Text(
                          'Name: $name',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const  SizedBox(height: 10.0),
                        Text(
                          'Email: $femail',
                          style: const TextStyle(fontSize: 18.0),
                        ),

                        const SizedBox(height: 10.0),
                        Text(
                          'Route Number: $routeNumber',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const   SizedBox(height: 10.0),
                        Text(
                          'Travel Date: ${DateFormat('yyyy-MM-dd').format(travelDate)}',
                          style:const  TextStyle(fontSize: 18.0),
                        ),
                        const  SizedBox(height: 10.0),
                        Text(
                          'Transaction ID: $transactionid',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const   SizedBox(height: 20.0),
                        QrImageView(
                          data:
                          '$name\n$femail\n$routeNumber\n${DateFormat('yyyy-MM-dd').format(travelDate)}\n$transactionid',
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: 281,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  _saveImage();
                  Navigator.popUntil(context, ModalRoute.withName('/hosteliteHome'));

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF03314B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Padding(
                  padding:  EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20),
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
