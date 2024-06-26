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

class LostAndFound extends StatefulWidget {
  const LostAndFound({Key? key}) : super(key: key);

  @override
  LostAndFoundState createState() => LostAndFoundState();
}

class LostAndFoundState extends State<LostAndFound> {
  late String femail;
  File? _image;
  final picker = ImagePicker();
  TextEditingController itemname = TextEditingController();
  TextEditingController routeNo = TextEditingController();
  TextEditingController details = TextEditingController();
  late Uint8List imageBytes;
  late String base64String;

  @override
  Widget build(BuildContext context) {
    femail = (ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>)['femail'];

   /* Future<void> getImageFromGallery() async {
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
    }*/

    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Color(0xFF03314B),
        title: Text('Lost Items', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            FutureBuilder<List<Map<String, dynamic>>?>(
              future: MongoDatabase().fetchlostitems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No report history available.'));
                } else {
                  return Column(
                    children: snapshot.data!.map((report) {
                      print(report['details']);
                      print(report['base64string']);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  report['itemname'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Route No: ${report['routeno']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Details: ${report['details']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              report['base64string'] != null
                                  ?Image.memory(
                                base64Decode(report['base64string']!.split(',').last),
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                height: 150,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Text(
                                    'No Image',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final itemId = report['_id']; // Safely get the item id as an ObjectId

                                    if (itemId != null) {
                                      bool alreadyClaimed = await MongoDatabase.isItemClaimed(itemId, femail);
                                      print(alreadyClaimed);

                                      if (alreadyClaimed) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('You have already claimed this item'),
                                          ),
                                        );
                                      } else {
                                        ClaimItemModel newItem = ClaimItemModel(
                                          itemid: itemId,
                                          itemname: report['itemname'],
                                          routeno: report['routeno'],
                                          details: report['details'],
                                          base64string: report['base64string'],
                                          claimby: femail,
                                        );
                                        // Call the function to insert the data into the database
                                        await MongoDatabase.claimReportItem(newItem);

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Request is submitted'),
                                          ),
                                        );
                                      }
                                    } else {
                                      // Handle the case where 'id' is null
                                      print('Item id is null');
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
                                        vertical: 10),
                                    child: Text(
                                      'Claim',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
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
    );
  }
}
