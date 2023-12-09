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
  List<String> role = ['Student', 'Teacher'];
  List<int> routes = [];
  List<String> stops = [];
  String? selectedRole;
  int? selectedRoute;
  String? selectedStop;
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
  var femailController = new TextEditingController();
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
                          hintText: "Select Role",
                          fillColor: const Color.fromARGB(27, 0, 0, 0),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      items: role
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child:
                                    Text(item, style: TextStyle(fontSize: 15)),
                              ))
                          .toList(),
                      onChanged: (item) => setState(() => selectedRole = item),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                          hintText: "Select Route",
                          fillColor: const Color.fromARGB(27, 0, 0, 0),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      items: routes
                          .map((item) => DropdownMenuItem<int>(
                                value: item,
                                child: Text(item.toString(),
                                    style: TextStyle(fontSize: 15)),
                              ))
                          .toList(),
                      onChanged: (item) {
                        setState(() {
                          selectedRoute = item;
                          selectedStop = null;

                          // Call the method to fetch stops for the selected route
                          fetchStopsForRoute(item!);
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          hintText: "Select Stop",
                          fillColor: const Color.fromARGB(27, 0, 0, 0),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      items: stops
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child:
                                    Text(item, style: TextStyle(fontSize: 15)),
                              ))
                          .toList(),
                      onChanged: (item) => setState(() => selectedStop = item),
                      value: selectedStop, // Add this line to
                    ),
                    SizedBox(
                      height: 25,
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
                        } else {
                          _verifyEmail(
                              fnameController.text,
                              femailController.text,
                              fpasswordController.text,
                              selectedRole!,
                              selectedRoute!,
                              selectedStop!);
                        }
                        // Code to be executed when the button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2BB45A),
                        padding: EdgeInsets.all(13.0),
                        // minimumSize: Size(300.0, 0),
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
    } else {
      Navigator.pushNamed(context, '/verifyEmail', arguments: {
        'fname': fname,
        'femail': femail,
        'fpassword': fpassword,
        'frole': frole,
        'froute': froute,
        'fstop': fstop
      });
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
}
