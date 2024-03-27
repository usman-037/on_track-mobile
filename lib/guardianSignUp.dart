import 'package:flutter/material.dart';
import 'package:ontrack/MongoDBModel.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class GuardianSignUp extends StatefulWidget {
  const GuardianSignUp({super.key});

  @override
  State<GuardianSignUp> createState() => _GuardianSignUpState();
}

class _GuardianSignUpState extends State<GuardianSignUp> {
  BuildContext? _qrDialogContext;
BuildContext? _signup;
  late BuildContext _scaffoldContext;
  List<int> routes = [];
  List<String> stops = [];
  String? selectedRole;
  int? selectedRoute;
  String? selectedStop;
  bool _showPassword = false;
  bool _showPassword2 = false;
  late String code;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String qrData = '';

  @override
  void initState() {
    super.initState();
    _signup=context;
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
      builder: (context) =>
          Center(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        body: Builder(
          builder: (BuildContext scaffoldContext) {
            _scaffoldContext = scaffoldContext;
            return Stack(
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
                        'ON',
                        [Color(0xFFB0C5D0), Colors.blueGrey],
                      ),
                      _buildGradientText(
                        'TRACK',
                        [Color(0xFFA9EAFF), Color(0xFF08C4FF)],
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.28,
                      right: 35,
                      left: 35,
                    ),
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
                              icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
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
                              icon: Icon(_showPassword2 ? Icons.visibility : Icons.visibility_off),
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
                                fpasswordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please fill in all the fields'),
                                ),
                              );
                            } else if (fpasswordController.text !=
                                retypepasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Passwords do not match'),
                                ),
                              );
                              fpasswordController.clear();
                              retypepasswordController.clear();
                            } else {
                              _startQRScanner();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(MediaQuery.of(context).size.width, 40),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }


  Future<List<int>> fetchRoutesList() async {
    List<int> result = await MongoDatabase.queryFetchRoutes();
    return result; // Return true if email exists, false otherwise
  }

  Future<bool> isEmailAlreadyExists(String email) async {
    var result = await MongoDatabase.queryEmailExists(email);
    return result; // Return true if email exists, false otherwise
  }

  void _startQRScanner() {
    showDialog(
      context: context,
      builder: (context) {
        _qrDialogContext = context; // Save the dialog context
        return Dialog(
          child: Container(
            height: 300,
            width: 300,
            child: Column(
              children: [
                const Text(
                  "Scan Student's QR Code",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Expanded(
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the QR scanner dialog
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        String? qrCode = scanData.code;
        List<String>? qrParts = qrCode?.split("|");
        String? email = qrParts?[0];
        Navigator.of(_qrDialogContext!).pop();
        if (await MongoDatabase.queryEmailExists(email!)) {
          String fname = fnameController.text;
          String fphone = fphoneController.text;
          String fpassword = fpasswordController.text;
          String fstdemail = email;
          _insertData(context,fname, fphone, fpassword, fstdemail);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Student not found!')));
        }
      });
    });
  }

  Future<void> _insertData(BuildContext cont,String fname, String fphone, String fpassword, String fstdemail) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: CircularProgressIndicator(),
        ),
      );

      final data = GuardianModel(
        name: fname,
        email: fphone,
        password: fpassword,
        studentEmail: fstdemail,
      );

      final phoneStdmailexists = await MongoDatabase.queryphoneStdmailexists(fphone, fstdemail);
      print('initialC');
      print(context);
      if (!phoneStdmailexists) {
        final inserted = await MongoDatabase.insertGuardian(data);

        if (inserted) {
          final scaffoldContext = ScaffoldMessenger.of(context);
          scaffoldContext.showSnackBar(
            SnackBar(
              content: Text('Signup successful!'),
              duration: Duration(seconds: 1),
            ),
          );
          print("Navigating to login screen...");
          Navigator.pushReplacementNamed(cont, '/login');
        }
      } else {
        final scaffoldContext = ScaffoldMessenger.of(context);
        scaffoldContext.showSnackBar(
          SnackBar(
            content: Text('Guardian already registered for student email'),
            duration: Duration(seconds: 3),
          ),
        );
        print("Navigating to signup screen...");
        Navigator.pushReplacementNamed(context, '/signup');
      }
    } catch (e) {
      print('Error inserting data: $e');
    } finally {
      Navigator.pop(context);
    }
  }


}

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
