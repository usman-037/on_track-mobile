import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordController2 = TextEditingController();

  bool _showPassword = false;
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
          'Edit Profile',
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
                    controller: passwordController,
                    maxLength: 25,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: const Color.fromARGB(27, 0, 0, 0),
                      filled: true,
                      hintText: "Old Password",
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
                      if (passwordController.text.isEmpty ||
                          newPasswordController.text.isEmpty ||
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
                      }
                      else if(passwordController.text==newPasswordController.text){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Old Password and New Password cannot be the same!')),
                        );
                        passwordController.clear();
                        newPasswordController.clear();
                        newPasswordController2.clear();

                      }
                      else {
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
    String oldPassword = passwordController.text;
    String newPassword = newPasswordController.text;
    if (await MongoDatabase.queryEmailandPasswordExists(femail, oldPassword) !=
        true) {
      Navigator.pop(context); // Dismiss the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect Old Password')),
      );
      passwordController.clear();
    } else {
      await MongoDatabase.queryChangePassword(femail, oldPassword, newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password Updated Successfully!')),
      );
      Navigator.of(context).popUntil(ModalRoute.withName('/passengerHome'));
    }
  }
}
