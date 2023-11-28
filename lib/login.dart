import 'package:flutter/material.dart';
import 'package:fancy_button_flutter/fancy_button_flutter.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class Login extends StatelessWidget {
  static final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 130),
              child: const Text(
                'ON TRACK',
                style: TextStyle(
                    color: Color.fromARGB(255, 43, 180, 90),
                    fontSize: 50,
                    fontFamily: 'LuckiestGuy'),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: const Color.fromARGB(27, 0, 0, 0),
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: passwordController,
                            style: const TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: const Color.fromARGB(27, 0, 0, 0),
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                            width: 10,
                          ),
                          FancyButton(
                              button_text: "LOGIN",
                              button_height: 40,
                              button_width: MediaQuery.sizeOf(context).width,
                              button_radius: 10,
                              button_color: Colors.green,
                              button_outline_color: Colors.green,
                              button_outline_width: 1,
                              button_text_color: Colors.white,
                              button_icon_color: Colors.white,
                              icon_size: 22,
                              button_text_size: 15,
                              onClick: () {
                                _performlogin(context);
                              }),
                          const SizedBox(
                            height: 30,
                            width: 10,
                          ),
                          FancyButton(
                              button_text: "Don't have an account? Sign up",
                              button_height: 40,
                              button_width: MediaQuery.sizeOf(context).width,
                              // button_radius: 10,
                              button_color: Colors.transparent,
                              button_outline_color: Colors.transparent,
                              // button_outline_width: 1,
                              button_text_color: Colors.black,
                              button_icon_color: Colors.white,
                              icon_size: 22,
                              button_text_size: 15,
                              onClick: () {
                                Navigator.pushNamed(context, '/signup');
                                // print("Button clicked");
                              }),
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
    );
  }

  Future<void> _performlogin(BuildContext context) async {
    String femail = emailController.text;
    String fpassword = passwordController.text;
    if (await isEmailandPasswordAlreadyExists(femail, fpassword)) {
      String userName = await getUserName(femail);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful!')),
      );
      // Navigate to the home screen or perform any desired action
      Navigator.pushReplacementNamed(context, '/passengerHome',
          arguments: {'userName': userName});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  Future<String> getUserName(String femail) async {
    var result = await MongoDatabase.queryGetUsernameFromEmail(femail);
    return result;
  }

  Future<bool> isEmailandPasswordAlreadyExists(
      String femail, String fpassword) async {
    var result =
        await MongoDatabase.queryEmailandPasswordExists(femail, fpassword);
    return result;
  }
}
