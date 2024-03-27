import 'package:flutter/material.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class ViewRouteStops extends StatefulWidget {
  const ViewRouteStops({Key? key}) : super(key: key);

  @override
  State<ViewRouteStops> createState() => _ViewRouteStopsState();
}

class _ViewRouteStopsState extends State<ViewRouteStops> {
  late String userName;
  late int routeNo;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userName = arguments['userName'];
    routeNo = arguments['routeNo'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Route Stops',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF03314B),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Route: $routeNo\nStops and Arrival Times',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Future.wait([
                MongoDatabase.queryFetchStops(routeNo),
                MongoDatabase.queryFetchArrivalTimes(routeNo),
              ]),
              builder: (context, AsyncSnapshot<List<List<String>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<String> stops = snapshot.data![0];
                  List<String> arrivalTimes = snapshot.data![1];
                  return ListView.builder(
                    itemCount: stops.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            stops[index],
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 17,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          arrivalTimes.length > index
                              ? '${arrivalTimes[index]} AM'
                              : 'N/A',
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 17,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
