import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ontrack/MongoDBModel.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class Reportanissue extends StatefulWidget {
  const Reportanissue({Key? key}) : super(key: key);

  Reportanissuestate createState() => Reportanissuestate();
}

class Reportanissuestate extends State<Reportanissue> {
  List<String> type = ['Bus', 'Driver', 'A Bug', 'Other'];
  String? selectedType;
  late String femail;
//late String description;
  TextEditingController descriptionController = new TextEditingController();
  late String status;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    femail = arguments['femail'];
    //fetchrequest();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        appBar: AppBar(
          backgroundColor: Color(0xFF03314B),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Report Issue'),
              Tab(text: 'History'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
          ),
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            child:Container(
              child: Column(
                children: [
                  Card(
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25.0),
                                  child: Text(
                                    'I would like to report about',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              // Add some space between text and dropdown
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    hintText: "Choose",
                                    fillColor: const Color(0xFFE3E2E2),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: type
                                      .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item,
                                        style: TextStyle(fontSize: 15)),
                                  ))
                                      .toList(),
                                  onChanged: (item) =>
                                      setState(() => selectedType = item),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 60),
                          TextField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              hintText: 'Add comments here...',
                              fillColor: const Color(0xFFE3E2E2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            maxLines: 4, // Adjust the number of lines as needed
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width:
                    MediaQuery.of(context).size.width / 2, // Adjust the width
                    height: MediaQuery.of(context).size.height / 15,
                    child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        bool result = await checklimit();
                        bool check = await checkuser();
                        int count = await fetchCount();

                        if (selectedType == null ||
                            descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please fill in all the fields')),
                          );
                        } else if (result) {
                          if (check) {
                            insertreportdata(femail, selectedType!,
                                descriptionController.text, 'Unfulfilled', 1);
                          } else {
                            insertreportdata(
                                femail,
                                selectedType!,
                                descriptionController.text,
                                'Unfulfilled',
                                count + 1);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'You have reached the maximum report limit.'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(MediaQuery.of(context).size.width, 80),
                        backgroundColor: Color(0xFF03314B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<Map<String, dynamic>>?>(
                  future: MongoDatabase.fetchUserReportHistory(femail),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No report history available.');
                    } else {
                      return Column(
                        children: snapshot.data!.map((report) {
                          return Card(
                            color: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Subject',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        report['type'] ?? '',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Description',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        report['description'] ?? '',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Status',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        report['status'] ?? '',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> insertreportdata(String femail, String type, String description,
      String status, int reportcount) async {
    final data = reportissueModel(
        email: femail,
        type: type,
        description: description,
        status: status,
        reportcount: reportcount);
    await MongoDatabase.insertReport(data);
    setState(() {
      selectedType = null;
      descriptionController.clear();
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request is submitted!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<bool> checklimit() async {
    var result = await MongoDatabase.checkReportLimit(femail);
    return result;
  }

  Future<bool> checkuser() async {
    var result = await MongoDatabase.checkuserexist(femail);
    return result;
  }

  Future<int> fetchCount() async {
    var result = await MongoDatabase.fetchcount(femail);
    return result;
  }
}