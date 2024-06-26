import 'package:flutter/material.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:math';

class Mysignup extends StatefulWidget {
  const Mysignup({super.key});

  @override
  State<Mysignup> createState() => _MysignupState();
}

class _MysignupState extends State<Mysignup> {
  List<String> role = ['Student', 'Faculty'];
  List<int> routes = [];
  List<String> stops = [];
  String? selectedRole;
  int? selectedRoute;
  String? selectedStop;
  bool _showPassword = false;
  bool _showPassword2 = false;
  late String code;

  //scrolling variables...
  final ScrollController _scrollController = ScrollController();
  bool _showMoreContent = false;
  bool _showScrollUpButton = false;

  @override
  void initState() {
    super.initState();
    fetchData(); // Assuming fetchData is an asynchronous function
  }

  Future<void> fetchData() async {
    List<int> result = await fetchRoutesList();
    setState(() {
      routes = result;
      routes.sort((a, b) => a.compareTo(b));
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
  var femailController = new TextEditingController();
  var fpasswordController = new TextEditingController();
  var retypepasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Stack(
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
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.28,
                right: 35,
                left: 35,
              ),
              child: Center(
                child: Text(
                  'Enter Credentials',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.32,
                right: 35,
                left: 35,
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  TextField(
                    controller: fnameController,
                    maxLength: 25,
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: const Color(0xFFE3E2E2),
                      filled: true,
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: femailController,
                    maxLength: 30,
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: const Color(0xFFE3E2E2),
                      filled: true,
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: fpasswordController,
                    maxLength: 25,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: const Color.fromARGB(27, 0, 0, 0),
                      filled: true,
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
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
                  SizedBox(height: 10),
                  TextField(
                    controller: retypepasswordController,
                    maxLength: 25,
                    obscureText: !_showPassword2,
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: const Color.fromARGB(27, 0, 0, 0),
                      filled: true,
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
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
                  SizedBox(height: 10),
                  DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: "Select Role",
                        filled: true,
                        fillColor: const Color(0xFFE3E2E2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: role.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (item) => setState(() => selectedRole = item),
                      icon: Icon(Icons.arrow_drop_down_circle_outlined),
                      iconSize: 36.0,
                      iconEnabledColor: Colors.grey,
                      isExpanded: true,
                      elevation: 8,
                      dropdownColor: const Color(0xFFE3E2E2),
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      right: 35,
                      left: 35,
                    ),
                    child: Center(
                      child: Text(
                        'Select Route',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/busesroutes',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                          side: BorderSide(width: 0.8, color: Colors.black),
                        ),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.80,
                        height: 30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Tap to View Buses Routes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  DropdownButtonHideUnderline(
                    child: SingleChildScrollView(
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          hintText: "Select Route",
                          filled: true,
                          fillColor: const Color(0xFFE3E2E2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: routes.map((item) {
                          return DropdownMenuItem<int>(
                            value: item,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                item.toString(),
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (item) {
                          setState(() {
                            selectedRoute = item;
                            selectedStop = null;

                            // Call the method to fetch stops for the selected route
                            fetchStopsForRoute(item!);
                          });
                        },
                        icon: Icon(Icons.arrow_drop_down_circle_outlined),
                        iconSize: 36.0,
                        iconEnabledColor: Colors.grey,
                        isExpanded: true,
                        elevation: 8,
                        dropdownColor: const Color(0xFFE3E2E2),
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                        menuMaxHeight: 200,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: "Select Stop",
                        filled: true,
                        fillColor: const Color(0xFFE3E2E2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: stops.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (item) => setState(() => selectedStop = item),
                      value: selectedStop,
                      icon: Icon(Icons.arrow_drop_down_circle_outlined),
                      iconSize: 36.0,
                      iconEnabledColor: Colors.grey,
                      isExpanded: true,
                      elevation: 8,
                      dropdownColor: const Color(0xFFE3E2E2),
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                      menuMaxHeight: 200,
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (fnameController.text.isEmpty ||
                          femailController.text.isEmpty ||
                          fpasswordController.text.isEmpty ||
                          selectedRole == null ||
                          selectedRoute == null ||
                          selectedStop == null) {
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
                        _verifyEmail(
                            fnameController.text,
                            femailController.text,
                            fpasswordController.text,
                            selectedRole!,
                            selectedRoute!,
                            selectedStop!);
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
                      style: TextStyle(
                        color: Color(0xFFD7D8E2),
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyEmail(String fname, String femail, String fpassword,
      String frole, int froute, String fstop) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Check if the email already exists
    if (await isEmailAlreadyExists(femail)) {
      Navigator.pop(context); // Dismiss the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Email already exists! Please use a different email')),
      );
    } else if (await _sendCode(femail)) {
      Navigator.pushReplacementNamed(context, '/verifyEmail', arguments: {
        'fname': fname,
        'femail': femail,
        'fpassword': fpassword,
        'frole': frole,
        'froute': froute,
        'fstop': fstop,
        'matchCode': code
      }).then((_) {
        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context); // Dismiss the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect email!')),
      );
      femailController.clear();
    }
  }

  Future<List<int>> fetchRoutesList() async {
    List<int> result = await MongoDatabase.queryFetchRoutes();
    return result; // Return true if email exists, false otherwise
  }

  Future<bool> isEmailAlreadyExists(String email) async {
    // Query the database to check if the email already exists
    var result = await MongoDatabase.queryEmailExists(email);
    return result; // Return true if email exists, false otherwise
  }

  String _generateRandomCode() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<bool> _sendCode(String femail) async {
    code = _generateRandomCode();
    try {
      var userEmail = 'YOUR GMAIL HERE';
      var password = 'YOUR PASSWORD HERE';
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
      Navigator.pop(context);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
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
}
