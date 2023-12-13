import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordController2 = TextEditingController();

  bool _showPassword2 = false;
  bool _showPassword3 = false;

  @override
  Widget build(BuildContext context) {
    final femail = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['femail'];
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF03314B),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child: Column(children: [
              Container(
                margin: const EdgeInsets.only(left: 35, right: 35),
                child: Column(children: [
                  TextField(
                    controller: newPasswordController,
                    maxLength: 25,
                    obscureText: !_showPassword2,
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: const Color.fromARGB(27, 0, 0, 0),
                      filled: true,
                      hintText: "New Password",
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: newPasswordController2,
                    maxLength: 25,
                    obscureText: !_showPassword3,
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
                        icon: Icon(_showPassword3
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showPassword3 = !_showPassword3;
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
                      if (newPasswordController.text.isEmpty ||
                          newPasswordController2.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Please fill in all the fields')),
                        );
                      } else if (newPasswordController.text !=
                          newPasswordController2.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords do not match')),
                        );
                        newPasswordController.clear();
                        newPasswordController2.clear();
                      } else {
                        _updatePassword(context, femail);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Color(0xFF03314B),
                    ),
                    child: const Text(
                      "UPDATE PASSWORD",
                      style:
                          TextStyle(color: Color(0xFFD7D8E2), fontSize: 15.0),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Future<void> _updatePassword(BuildContext context, String femail) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    String newPassword = newPasswordController.text;

    await MongoDatabase.queryForgotPassword(femail, newPassword);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password Updated Successfully!')),
    );
    Navigator.pushReplacementNamed(context, '/login');
    // Navigator.of(context).popUntil(ModalRoute.withName('/login'));

  }
}
