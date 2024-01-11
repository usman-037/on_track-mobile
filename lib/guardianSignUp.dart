import 'package:flutter/material.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:math';


class GuardianSignUp extends StatefulWidget {
  const GuardianSignUp({super.key});

  @override
  State<GuardianSignUp> createState() => _GuardianSignUpState();
}

class _GuardianSignUpState extends State<GuardianSignUp> {
  List<int> routes = [];
  List<String> stops = [];
  String? selectedRole;
  int? selectedRoute;
  String? selectedStop;
  bool _showPassword = false;
  bool _showPassword2 = false;
  late String code;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // late QRViewController controller;
  String qrData = '';
  @override
  void initState() {
    super.initState();
    fetchData(); // Assuming fetchData is an asynchronous function
  }

  Future<void> fetchData() async {
    List<int> result = await fetchRoutesList();
    setState(() {
      routes = result;
    });
  }

  Future<void> fetchStopsForRoute(int routeNumber) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    List<String> stopsList = await MongoDatabase.queryFetchStops(routeNumber);
    setState(() {
      stops = stopsList;
      selectedStop = null;
      Navigator.pop(context); // Reset selected stop when route changes
    });
  }

  var fnameController = new TextEditingController();
  var fphoneController = new TextEditingController();
  var fpasswordController = new TextEditingController();
  var retypepasswordController = new TextEditingController();
  var getEmailController=new TextEditingController();
  var getNameController=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        body: Stack(
          children: [
            Positioned(
              top: -50,
              left: -35,
              right: -50,
              child: Container(
                alignment: Alignment.topCenter,
                height: 253,
                width: 452,
                decoration: ShapeDecoration(
                  color: Color(0xFF03314B),
                  shape: OvalBorder(),
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 6.8,
              top: MediaQuery.of(context).size.height / 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGradientText(
                      'ON', [Color(0xFFB0C5D0), Colors.blueGrey]),
                  _buildGradientText(
                      'TRACK', [Color(0xFFA9EAFF), Color(0xFF08C4FF)]),
                ],
              ),
            ),
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: fnameController,
                      maxLength: 25,
                      decoration: InputDecoration(
                        counterText: '',
                        fillColor: const Color(0xFFE3E2E2),
                        filled: true,
                        hintText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: fphoneController,
                      maxLength: 15,
                      decoration: InputDecoration(
                        counterText: '',
                        fillColor: const Color(0xFFE3E2E2),
                        filled: true,
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: fpasswordController,
                      maxLength: 25,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        counterText: '',
                        fillColor: const Color.fromARGB(27, 0, 0, 0),
                        filled: true,
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          // Add the suffixIcon
                          icon: Icon(_showPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: retypepasswordController,
                      maxLength: 25,
                      obscureText: !_showPassword2,
                      decoration: InputDecoration(
                        counterText: '',
                        fillColor: const Color.fromARGB(27, 0, 0, 0),
                        filled: true,
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          // Add the suffixIcon
                          icon: Icon(_showPassword2
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _showPassword2 = !_showPassword2;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (fnameController.text.isEmpty ||
                            fphoneController.text.isEmpty ||
                            fpasswordController.text.isEmpty ){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please fill in all the fields')),
                          );
                        } else if (fpasswordController.text !=
                            retypepasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Passwords do not match')),
                          );
                          fpasswordController.clear();
                          retypepasswordController.clear();
                        } else {
                         scanQrCode();
                          // _verifyEmail(
                          //     fnameController.text,
                          //     fphoneController.text,
                          //     fpasswordController.text,
                          //     selectedRole = "Hostelite",
                          //     selectedRoute = 0,
                          //     selectedStop = 'null');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Color(0xFF03314B),
                        padding: EdgeInsets.all(13.0),
                      ),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> scanQrCode() async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Scaffold(
    //       body: QRView(
    //         key: qrKey,
    //         onQRViewCreated: _onQRViewCreated,
    //       ),
    //     ),
    //   ),
    // );
  }

  // void _onQRViewCreated(QRViewController controller) {
    // this.controller = controller;
    // controller.scannedDataStream.listen((scanData) {
    //   setState(() {
    //     qrData = scanData.code!;
    //     List<String> qrParts = qrData.split('|');
    //
    //     getEmailController.text = qrParts[0];
    //     getNameController.text = qrParts[1];
    //   });
    //
    //   // Add any additional processing or validation logic as needed
    //
    //   Navigator.pop(context); // Close the QR code scanner screen
    // });
  // }
  // Future<void> _verifyEmail(String fname, String femail, String fpassword,
  //     String frole, int froute, String fstop) async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );
  //
  //   // Check if the email already exists
  //   if (await isEmailAlreadyExists(femail)) {
  //     Navigator.pop(context); // Dismiss the dialog
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content:
  //               Text('Email already exists! Please use a different email')),
  //     );
  //     fphoneController.clear();
  //   } else if (await _sendCode(femail)) {
  //     Navigator.pushNamed(context, '/verifyEmail', arguments: {
  //       'fname': fname,
  //       'femail': femail,
  //       'fpassword': fpassword,
  //       'frole': frole,
  //       'froute': froute,
  //       'fstop': fstop,
  //       'matchCode': code
  //     }).then((_) {
  //       Navigator.pop(context);
  //     });
  //   } else {
  //     Navigator.pop(context); // Dismiss the dialog
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Incorrect email!')),
  //     );
  //     fphoneController.clear();
  //   }
  // }
  //
  Future<List<int>> fetchRoutesList() async {
    List<int> result = await MongoDatabase.queryFetchRoutes();
    return result; // Return true if email exists, false otherwise
  }
  //
  // Future<bool> isEmailAlreadyExists(String email) async {
  //   // Query the database to check if the email already exists
  //   var result = await MongoDatabase.queryEmailExists(email);
  //   return result; // Return true if email exists, false otherwise
  // }
  //
  // String _generateRandomCode() {
  //   Random random = Random();
  //   return (100000 + random.nextInt(900000)).toString();
  // }
  //
  // Future<bool> _sendCode(String femail) async {
  //   code = _generateRandomCode();
  //   try {
  //     var userEmail = 'ontrackfyp@gmail.com';
  //     var password = 'rrykntjptdaxaqqa';
  //     var message = Message();
  //     message.subject = 'Verification Code for On Track';
  //     message.text = 'Your verification code is $code';
  //     message.from = Address(userEmail);
  //     message.recipients.add(femail);
  //     var smtpServer = gmail(userEmail, password);
  //     final sendReport = await send(message, smtpServer);
  //     print('Email sent: ' + sendReport.toString());
  //     return true;
  //   } on MailerException catch (e) {
  //     print('Error sending email! $e');
  //
  //     for (var p in e.problems) {
  //       print('Problem: ${p.code}: ${p.msg}');
  //     }
  //     return false;
  //   }
  // }
  //
  Widget _buildGradientText(String text, List<Color> colors) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 50,
          fontFamily: 'FasterOne',
          color: Colors.white,
        ),
      ),
    );
  }
}
