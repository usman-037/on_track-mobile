import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:ontrack/MongoDBModel.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class Mysignup extends StatefulWidget {
  const Mysignup({super.key});

  @override
  State<Mysignup> createState() => _MysignupState();
}

class _MysignupState extends State<Mysignup> {
  List<String> role = ['Select', 'Student', 'Teacher'];
  String? selectedItem = 'Select';
  var fnameController = new TextEditingController();
  var femailController = new TextEditingController();
  var fphonenumberController = new TextEditingController();
  var fpasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        body: Stack(
          children: [
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
                    top: MediaQuery.of(context).size.height * 0.3,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: fnameController,
                      decoration: InputDecoration(
                          fillColor: const Color.fromARGB(27, 0, 0, 0),

                          filled: true,

                          hintText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: fphonenumberController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(27, 0, 0, 0),

                          hintText: 'Phone Number',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: femailController,
                      decoration: InputDecoration(
                          fillColor: const Color.fromARGB(27, 0, 0, 0),

                          filled: true,
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: fpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: const Color.fromARGB(27, 0, 0, 0),

                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          fillColor: const Color.fromARGB(27, 0, 0, 0),

                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      value: selectedItem,
                      items: role
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child:
                                    Text(item, style: TextStyle(fontSize: 15)),
                              ))
                          .toList(),
                      onChanged: (item) => setState(() => selectedItem = item),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _insertData(
                            fnameController.text,
                            fphonenumberController.text,
                            femailController.text,
                            fpasswordController.text,
                            selectedItem!);
                        // Code to be executed when the button is pressed
                      },
                      // Optionally, you can reset the dropdown selection to its initial state

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2BB45A),
                        padding: EdgeInsets.all(13.0),
                        minimumSize: Size(300.0, 0),
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

  Future<void> _insertData(String fname, String fphonenumber, String femail,
      String fpassword, String frole) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    // Validate that all text fields are filled
    if (fname.isEmpty ||
        fphonenumber.isEmpty ||
        femail.isEmpty ||
        fpassword.isEmpty ||
        frole == 'Select') {
      Navigator.pop(context); // Dismiss the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the fields')),
      );
    } else {
      // Check if the email already exists
      if (await isEmailAlreadyExists(femail)) {
        Navigator.pop(context); // Dismiss the dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Email already exists! Please use a different email')),
        );
      } else {
        var _id = M.ObjectId();
        final data = MongoDbModel(
            id: _id,
            name: fname,
            phonenumber: fphonenumber,
            email: femail,
            password: fpassword,
            role: frole);
        await MongoDatabase.insert(data);
        fnameController.clear();
        fphonenumberController.clear();
        femailController.clear();
        fpasswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signup successfully!'),
            duration: Duration(seconds: 1),
          ),
        );
        Navigator.pushNamed(context, '/login');
      }
    }
  }
  Future<bool> isEmailAlreadyExists(String email) async {
    // Query the database to check if the email already exists
    var result = await MongoDatabase.queryEmailExists(email);
    return result; // Return true if email exists, false otherwise
  }
}
