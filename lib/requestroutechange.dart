import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ontrack/MongoDBModel.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;


class RequestRouteChange extends StatefulWidget {
  const RequestRouteChange({Key? key}) : super(key: key);

  @override
  _RequestRouteChangeState createState() => _RequestRouteChangeState();
}

class _RequestRouteChangeState extends State<RequestRouteChange> {
  List<int> routes = [];
  List<String> routestop = [];
  int? selectedRoute;
  String? selectedStops;
  TextEditingController commentController = new TextEditingController(); // Add comment controller
  late String femail;

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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    femail = arguments['femail'];

    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text('Route Change', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF03314B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Please select your desired route number from the list below.',
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                hintText: "Select Route",
                  fillColor: const Color(0xFFE3E2E2),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
              ),
              value: selectedRoute,
              items: routes.map((item) => DropdownMenuItem<int>(
                value: item,
                child: Text(item.toString(), style: TextStyle(fontSize: 15)),
              )).toList(),
              onChanged: (item) {
                setState(() {
                  selectedRoute = item;
                  selectedStops = null; // Reset selected stops when route changes
                  routestop.clear(); // Clear the routestop list
                });
                fetchRouteStops(selectedRoute!);
              },
            ),

            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: "Select Bus Stop",
                fillColor: const Color(0xFFE3E2E2),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              value: selectedStops,
              items: routestop.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: TextStyle(fontSize: 15)),
              )).toList(),
              onChanged: (item) {
                setState(() {
                  selectedStops = item;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: commentController,
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
            SizedBox(height: 20),
            Container(
              width: 281,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                if (
                selectedRoute == null ||
                 selectedStops == null || commentController.text.isEmpty ){
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                  content: Text('Please fill in all the fields')),
                          );
                          } else {
                  _insertData(
                    selectedRoute!,
                    selectedStops!,
                    commentController.text,
                  );
                }

                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF03314B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'Confirm',
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
  }

  Future<List<int>> fetchRoutesList() async {
    List<int> result = await MongoDatabase.queryFetchRoutes();
    return result; // Return true if email exists, false otherwise
  }

  Future<void> fetchRouteStops(int selectedroute) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    List<String> result = await MongoDatabase.queryFetchStops(selectedroute);

    setState(() {
      routestop = List.from(result);
    });
    Navigator.pop(context);
  }

  Future<void> _insertData(int froute,String fbusstops,String frouterequest) async {
    DateTime currentDate = DateTime.now();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(
            child: CircularProgressIndicator(),
          ),
    );
    bool request=await checkrequest(femail);
    if (!request)
    {
      var _id = M.ObjectId();
      final data = routerequestModel(
          id: _id,
          email: femail,
          route: froute,
          busstop: fbusstops,
          status: "Unfulfilled",
          routerequest: frouterequest,
          dateTime:currentDate);
      await MongoDatabase.insertRequest(data);
      setState(() {
        selectedRoute = null;
        selectedStops = null;
        commentController.clear();
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request is submitted!'),
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.pushNamed(context, '/passengerhome');
    }
    else{
      setState(() {
        selectedRoute = null;
        selectedStops = null;
        commentController.clear();
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your request is already pending!'),
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.pop(context);
    }
  }
 Future<bool> checkrequest(String femail) async{
    var result = await MongoDatabase.checkrouterequest(femail);
    return result;

  }
    }




