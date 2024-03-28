import 'package:flutter/material.dart';
import 'package:ontrack/choose_account.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:ontrack/getEmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;
  bool _stayLoggedIn = false;
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedEmail = prefs.getString('email');
      String? storedPassword = prefs.getString('password');
      String? storedaccountType = prefs.getString('accountType');
      String? storeduserName = prefs.getString('userName');
      print(storeduserName);
      print(storedaccountType);
      int? storedrouteNo = prefs.getInt('routeNo');

      if (storedEmail != null &&
          storedPassword != null &&
          storedaccountType != null &&
          storeduserName != null &&
          storedrouteNo != null) {
        _navigateToHome(storedEmail, storedPassword, storedaccountType,
            storeduserName, storedrouteNo);
      } else {
        print("values are null");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Container(
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
                top: MediaQuery.of(context).size.height / 3.25,
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
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.42),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextField(
                              controller: emailController,
                              maxLength: 30,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  counterText: '',
                                  fillColor: const Color.fromARGB(27, 0, 0, 0),
                                  filled: true,
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: passwordController,
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
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: _stayLoggedIn,
                                  onChanged: (value) {
                                    setState(() {
                                      _stayLoggedIn = value!;
                                    });
                                  },
                                ),
                                Text('Stay Logged In'),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (emailController.text.isEmpty ||
                                    passwordController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please fill in all the fields')),
                                  );
                                } else {
                                  _performlogin(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    Size(MediaQuery.of(context).size.width, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Color(0xFF03314B),
                              ),
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: Color(0xFFD7D8E2), fontSize: 15.0),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                              width: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return ChooseAccount();
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          var offsetAnimation =
                                              animation.drive(tween);

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Color(0xFF03314B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return GetEmail();
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Color(0xFF03314B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performlogin(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', emailController.text);
    prefs.setString('password', passwordController.text);
    String femail = emailController.text;
    String fpassword = passwordController.text;

    if (await isEmailandPasswordAlreadyExists(femail, fpassword)) {
      String userName = await getUserName(femail);
      int routeNo = 0;
      String accountType = await MongoDatabase.fetchAccountType(femail);

      if (accountType != "Guardian") {
        routeNo = await getRouteNo(femail);
      } else {
        String stdEmail = await getStdEmail(femail);
        routeNo = await getRouteNo(stdEmail);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('accountType', accountType);
      prefs.setString('userName', userName);
      prefs.setInt('routeNo', routeNo);
      prefs.setBool('isLoggedIn', _stayLoggedIn);
      await _navigateToHome(femail, fpassword, accountType, userName, routeNo);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect Email and Password.'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<String> getUserName(String femail) async {
    var result = await MongoDatabase.queryGetUsernameFromEmail(femail);
    return result;
  }

  Future<int> getRouteNo(String femail) async {
    int result = (await MongoDatabase.queryGetRouteNoFromEmail(femail)) as int;
    return result;
  }

  Future<String> getStdEmail(String femail) async {
    String result = (await MongoDatabase.querygetStdemail(femail));
    return result;
  }

  Future<bool> isEmailandPasswordAlreadyExists(
      String femail, String fpassword) async {
    var result =
        await MongoDatabase.queryEmailandPasswordExists(femail, fpassword);
    return result;
  }

  Future<void> _navigateToHome(String femail, String fpassword,
      String accountType, String userName, int routeNo) async {
    // Fetch account type based on user data

    switch (accountType) {
      case 'Guardian':
        Navigator.pushReplacementNamed(context, '/guardianHome', arguments: {
          'userName': userName,
          'femail': femail,
          'routeNo': routeNo
        });

        break;
      case 'Driver':
        Navigator.pushReplacementNamed(context, '/driverHome', arguments: {
          'userName': userName,
          'femail': femail,
          'routeNo': routeNo
        });
        break;

      case 'Student':
        Navigator.pushReplacementNamed(context, '/passengerHome', arguments: {
          'userName': userName,
          'femail': femail,
          'routeNo': routeNo
        });
      case 'Faculty':
        Navigator.pushReplacementNamed(context, '/passengerHome', arguments: {
          'userName': userName,
          'femail': femail,
          'routeNo': routeNo
        });
        break;
      case 'Supervisor':
        Navigator.pushReplacementNamed(context, '/supervisorHome', arguments: {
          'userName': userName,
          'femail': femail,
          'routeNo': routeNo
        });
      case 'Hostelite':
        Navigator.pushReplacementNamed(context, '/hosteliteHome', arguments: {
          'userName': userName,
          'femail': femail,
          'routeNo': routeNo
        });
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect Email and Password.'),
            duration: Duration(seconds: 3),
          ),
        );
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
