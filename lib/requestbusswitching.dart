import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ontrack/dbHelper/mongodb.dart';
import 'dart:math' as math;

class RequestBusSwitching extends StatefulWidget {
  const RequestBusSwitching({Key? key}) : super(key: key);

  @override
  State<RequestBusSwitching> createState() => _RequestBusSwitchingState();
}

class _RequestBusSwitchingState extends State<RequestBusSwitching> {
  List<RouteData> routes = []; // Define a list to hold route data
  bool _isLoading = true; // Track loading state
  bool _sortAscending = false; // Track sorting order

  late String userName;
  late int routeNo;

  @override
  void initState() {
    super.initState();
    _fetchRoutes(); // Fetch routes data
  }

  Future<void> _fetchRoutes() async {
    List<int> routeNumbers = await MongoDatabase.queryFetchLiveRoutes();
    List<Map<String, dynamic>> currentRoutesCoordinates = await MongoDatabase.queryFetchLiveTrackCoordinates(routeNo);

    for (int routeNumber in routeNumbers) {
      // Skip fetching if the routeNumber matches the current route number
      if (routeNumber == routeNo) continue;

      List<Map<String, dynamic>> coordinates = await MongoDatabase.queryFetchLiveTrackCoordinates(routeNumber);
      List<int> capacities = await MongoDatabase.queryFetchRouteCapacity(routeNumber);

      double totalDistance = 0;

      for (var coordinate in coordinates) {
        double distance = _calculateHaversineDistance(
          currentRoutesCoordinates[0]['latitude'] as double,
          currentRoutesCoordinates[0]['longitude'] as double,
          coordinate['latitude'] as double,
          coordinate['longitude'] as double,
        );

        totalDistance += distance;
      }

      // Round total distance to 3 decimal places
      totalDistance = double.parse(totalDistance.toStringAsFixed(2));

      // Store the total distance for this route
      routes.add(RouteData(routeNumber, capacities[0], totalDistance));
    }

    setState(() {
      _isLoading = false; // Set loading state to false
    }); // Update the UI
  }

  double _calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371; // Earth radius in kilometers
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c; // Distance in kilometers
    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userName = arguments['userName'];
    routeNo = arguments['routeNo'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Bus Switching',
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
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 0.0, 17.0),
                child: Text(
                  'Request the Nearest Bus',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              // BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 78),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Logic for button
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF03314B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.150,
                          height: 67,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Send Signal',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 17), // Add space below the button


              // COLUMNS
              Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 0.0, 0.0),
                child: Text(
                  'Live Distances',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              DataTable(
                sortColumnIndex: 1, // Set the default sorting column index
                sortAscending: _sortAscending, // Set the default sorting order
                columns: [
                  DataColumn(
                    label: Text(
                      'Routes',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    tooltip: 'Routes',
                  ),
                  DataColumn(
                    label: Text(
                      'Distance (Km)',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    tooltip: 'Distance',
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        routes.sort((a, b) => ascending ? a.distance.compareTo(b.distance) : b.distance.compareTo(a.distance));
                      });
                    },

                  ),
                ],
                rows: routes.map((route) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          '${route.routeNumber}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${route.distance}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
          // Centered loading indicator
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

// NOTE: CAPACITY IS NOT BEING USED AT THE MOMENT
class RouteData {
  final int routeNumber;
  final int capacity;
  final double distance;
  //final double latitude;
  //final double longitude;

  RouteData(this.routeNumber, this.capacity, this.distance);
}