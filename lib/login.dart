import 'package:flutter/material.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:ontrack/getEmail.dart';
import 'package:ontrack/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{return Future.value(false);},
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
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                              height: 20,
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
                                          return Mysignup();
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

    String femail = emailController.text;
    String fpassword = passwordController.text;
    if (await isEmailandPasswordAlreadyExists(femail, fpassword)) {
      String userName = await getUserName(femail);
      int routeNo = await getRouteNo(femail);
      Navigator.pop(context); // Dismiss the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful!')),
      );
      // Navigate to the home screen or perform any desired action
      Navigator.pushReplacementNamed(context, '/passengerHome', arguments: {
        'userName': userName,
        'femail': femail,
        'routeNo': routeNo
      });
    } else {
      Navigator.pop(context); // Dismiss the dialog
      emailController.clear();
      passwordController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
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

  Future<bool> isEmailandPasswordAlreadyExists(
      String femail, String fpassword) async {
    var result =
        await MongoDatabase.queryEmailandPasswordExists(femail, fpassword);
    return result;
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
