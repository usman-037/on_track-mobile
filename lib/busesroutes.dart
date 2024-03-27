import 'package:flutter/material.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class BusesRoutes extends StatefulWidget {
  const BusesRoutes({Key? key});

  @override
  State<BusesRoutes> createState() => _BusesRoutesState();
}

class _BusesRoutesState extends State<BusesRoutes> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buses Routes',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
             color: Colors.white,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF03314B),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search your stop',
                    labelStyle: TextStyle(color: Colors.black87, fontSize: 15, fontFamily: 'Poppins',),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              _buildRoutes(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoutes() {
    return FutureBuilder(
      future: Future.wait(List.generate(13, (index) =>
          Future.wait([
            MongoDatabase.queryFetchStops(index + 1),
            MongoDatabase.queryFetchArrivalTimes(index + 1),
          ])
      )),
      builder: (context, AsyncSnapshot<List<List<List<String>>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(13, (index) => _buildRouteSection(index + 1, 'Route ${index + 1}', snapshot.data![index][0], snapshot.data![index][1])),
          );
        }
      },
    );
  }

  Widget _buildRouteSection(int routeNumber, String routeTitle, List<String> stops, List<String> arrivalTimes) {
    // Filter stops based on search query
    if (_searchQuery.isNotEmpty) {
      var searchWords = _searchQuery.toLowerCase().split(' ');
      stops = stops.where((stop) {
        var stopLower = stop.toLowerCase();
        return searchWords.every((word) => stopLower.contains(word));
      }).toList();
    }

    // Only build the section if there are matching stops
    if (stops.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 18, left: 0, bottom: 0),
              child: Text(
                routeTitle,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataRowHeight: 20,
              columns: [
                DataColumn(
                  label: Flexible(
                    child: Text(
                      'Stops',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Arrival Times',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
              rows: List<DataRow>.generate(
                stops.length,
                    (index) => DataRow(
                  cells: [
                    DataCell(
                      Container(
                        width: 180,
                        child: Text(
                          stops[index],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 13,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        arrivalTimes.length > index ? '${arrivalTimes[index]} AM' : 'N/A',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 13,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(); // Return an empty container if there are no matching stops
    }
  }

}
