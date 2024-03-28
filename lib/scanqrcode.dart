import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ontrack/MongoDBModel.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dbHelper/mongodb.dart';

void main() => runApp(ScanQrCode());

class ScanQrCode extends StatefulWidget {
  @override
  _ScanQrCodeState createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Future<void> dispose() async {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        appBar: AppBar(
          title: Text('QR Code Scanner', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF03314B),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QRView(
                      key: _qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: Colors.red,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ),
                    Text(
                      'Scan QR Code',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
      _controller.scannedDataStream.listen((scanData) {
        print('Scanned data: ${scanData.code}');
        _controller.pauseCamera();
        String? qrCode = scanData.code;
        _showScanDialog(qrCode);
      });
    });
  }

  void _showScanDialog(String? qrCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('QR Code Scanned'),
          content: Text('Scanned QR code: $qrCode'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                if (qrCode != null) {
                  bool success = await _insertScannedQRData(qrCode);
                  if (success) {
                    _showSuccessDialog();
                  }
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _insertScannedQRData(String qrCode) async {
    List<String> qrData = qrCode.split('|');
    if (qrData.length == 4) {
      String femail = qrData[0];
      String userName = qrData[1];
      int routeNo = int.parse(qrData[2]);
      String currentDate = qrData[3];
      DateTime date = DateFormat('dd-MM-yyyy').parse(currentDate);
      String formattedDate = DateFormat('dd-MM-yyyy').format(date);

      bool success = await insertScannedQRData(femail, userName, routeNo, "present", formattedDate);
      return success;
    } else {
      print('Invalid QR code format');
      return false;
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Attendance updated successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> insertScannedQRData(String femail, String userName, int routeNo, String attendanceStatus, String currentDate) async {
    final data = Attendance(
      femail: femail,
      userName: userName,
      routeNo: routeNo,
      attendanceStatus: attendanceStatus,
      date: currentDate,
    );
    return await MongoDatabase.insertAttendance(data);
  }
}
