import 'package:flutter/material.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HosteliteHome extends StatefulWidget {
  const HosteliteHome({super.key});

  @override
  State<HosteliteHome> createState() => _HosteliteHomeState();
}

class _HosteliteHomeState extends State<HosteliteHome> {
  @override
  Widget build(BuildContext context) {
    final userName = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['userName'];
    final femail = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['femail'];
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Color(0xFF03314B),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFFE3E2E2),
        child: ListView(
          children: [
            ListTile(
              title: Text('About'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
      body: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          decoration: BoxDecoration(color: Color(0xFF03314B)),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Text(
            'Hi, $userName',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              height: 0,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
            padding: EdgeInsets.only(top: 70.0),
            child: Container(
              alignment: Alignment.topCenter,
              child: Text(
                'Hostelite',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Dela Gothic One',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            )),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 1.33,
          right: MediaQuery.of(context).size.width / 100,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/editProfile', arguments: {
                'femail': femail,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF03314B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 12,
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/edit.png',
                    width: 60,
                    height: 60,
                  ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 5,
          left: MediaQuery.of(context).size.width / 25,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE3E2E2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.25,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/trackroute.png',
                    width: 60,
                    height: 60,
                  ),
                  // ),
                  SizedBox(height: 10),
                  Text(
                    'Acquire Bus Pass',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 19,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2.5,
          left: MediaQuery.of(context).size.width / 25,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE3E2E2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.25,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/fee.png',
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Fee Status',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 19,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
