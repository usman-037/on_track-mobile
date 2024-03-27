import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ontrack/MongoDBModel.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'dart:convert';

class lostandfound extends StatefulWidget {
  const lostandfound({super.key});

  @override
  LostAndFoundState createState() => LostAndFoundState();
}

class LostAndFoundState extends State<lostandfound> {
  late String femail;
  File? _image;
  final picker = ImagePicker();
  TextEditingController itemname = new TextEditingController();
  TextEditingController routeNo = new TextEditingController();
  TextEditingController details = new TextEditingController();
  late Uint8List imageBytes;
  late String base64String;
  late bool hasClaimed = false;
//Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      imageBytes = await _image!.readAsBytes();
      base64String = base64Encode(imageBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image Inserted!'),
          duration: Duration(seconds: 1),
        ),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No image selected!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    femail = (ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>)['femail'];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        appBar: AppBar(
          backgroundColor: Color(0xFF03314B),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Report'),
              Tab(text: 'View'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
          ),
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 35, right: 35),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: itemname,
                    maxLength: 25,
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: const Color.fromARGB(27, 0, 0, 0),
                      filled: true,
                      hintText: "Item Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: routeNo,
                    maxLength: 25,
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: const Color.fromARGB(27, 0, 0, 0),
                      filled: true,
                      hintText: "Route Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: details,
                          maxLength: 200, // Adjust as needed
                          decoration: InputDecoration(
                            counterText: '',
                            fillColor: const Color.fromARGB(27, 0, 0, 0),
                            filled: true,
                            hintText: "Add Details...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                            icon: Icon(Icons.image),
                            onPressed: () {
                              getImageFromGallery();


                            }),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 281,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (itemname.text.isEmpty ||
                            routeNo.text.isEmpty ||
                            details.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please fill in all the fields')),
                          );
                        } else {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                          ReportAndClaimItemModel newItem =
                          ReportAndClaimItemModel(
                              id:M.ObjectId(),
                              itemname: itemname.text,
                              routeno: int.parse(routeNo.text),
                              details: details.text,
                              base64string: base64String,
                              itemstatus: 'Not Claimed');
                          // Call the function to insert the data into the database
                          await MongoDatabase.insertReportAndClaimItem(newItem);
                          Navigator.pop(context);
                          itemname.clear();
                          routeNo.clear();
                          details.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Report is submitted')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF03314B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
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
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<Map<String, dynamic>>?>(
                  future: MongoDatabase.fetchlostitems(),
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
                          print(report['details']);
                          print(report['base64string']);
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
                                        'ItemName',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        report['itemname'] ?? '',
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
                                        'RouteNo',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        report['routeno'].toString() ?? '',
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
                                        'Details',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        report['details'] ?? '',
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
                                        'Image',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        width: 100, // Set the width as needed
                                        height: 100,
                                        child: report['base64string'] != null
                                            ? Image.memory(
                                          base64Decode(
                                              report['base64string']),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                            : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[
                                            200], // Provide a placeholder color
                                          ),
                                          child: Center(
                                            child: Text(
                                              'No Image',
                                              style: TextStyle(
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: 281,
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () async {

                                        bool alreadyClaimed =
                                        await MongoDatabase.isItemClaimed(
                                            report['id'], femail);
                                        print(alreadyClaimed);

                                        if (alreadyClaimed) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'You have already claimed this item'),
                                            ),
                                          );
                                        } else {

                                          ClaimItemModel newItem =
                                          ClaimItemModel(
                                              itemid: report['id'],
                                              itemname: report['itemname'],
                                              routeno: report['routeno'],
                                              details: report['details'],
                                              base64string: report['base64string'],
                                              claimby: femail);
                                          // Call the function to insert the data into the database
                                          await MongoDatabase.claimReportItem(
                                              newItem);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(content: Text(
                                                'Request is submitted')),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF03314B),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: Text(
                                          'Claim',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
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
}
