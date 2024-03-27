import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ontrack/dbHelper/constant.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class GuardianTrackRoute extends StatefulWidget {
  const GuardianTrackRoute({super.key});

  @override
  State<GuardianTrackRoute> createState() => _GuardianTrackRouteState();
}

class _GuardianTrackRouteState extends State<GuardianTrackRoute> {
  int? routeNo;
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;
  LocationData? busLocation;
  List<LatLng> polylineCoordinates1 = [];
  List<LatLng> polylineCoordinates2 = [];
  BitmapDescriptor? personIcon;
  BitmapDescriptor? busIcon;
  Timer? timer;
  late Timer _timer;
  String _estimatedTime = '';

  Future<void> calculateEstimatedTime() async {
    if (busLocation == null || currentLocation == null) {
      return;
    }
    double distance = await Geolocator.distanceBetween(
      busLocation!.latitude!,
      busLocation!.longitude!,
      31.440245896341917,
      73.13314553744294,
    );

    double averageSpeed = 10.0; //meters per second
    int estimatedTimeInSeconds = (distance / averageSpeed).toInt();

    setState(() {
      _estimatedTime =
      '${(estimatedTimeInSeconds / 60).toStringAsFixed(0)} minutes';
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation();
      fetchBusLocation();
    });
    setCustomMarker();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (routeNo != null) {
        getPolyPoints();
        getPolyPointsFromBusLocationToStop();
        calculateEstimatedTime();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void setCustomMarker() async {
    personIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(50, 50)),
      "assets/icons/pinloc.png",
    );
    busIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(50, 50)),
      "assets/icons/buspin.png",
    );
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData newLoc) {
      setState(() {
        currentLocation = newLoc;
      });
    });
  }

  Future<void> fetchBusLocation() async {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      MongoDatabase.fetchLocationFromMongoDB(routeNo!).then((locationData) {
        setState(() {
          if (locationData != null) {
            busLocation = locationData;
          }
        });
      });
    });
  }

  Future<void> getPolyPoints() async {
    polylineCoordinates1.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    LatLng origin =
    LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    LatLng stopLocation = LatLng(31.440245896341917, 73.13314553744294);
    LatLng destination = stopLocation;

    print(
        "Polyline Coordinates (Current Location to Stop): $polylineCoordinates1");
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates1.addAll(result.points
          .map((PointLatLng point) => LatLng(point.latitude, point.longitude)));
    } else {
      print("Empty polyline points for route from $origin to $destination");
    }
  }

  Future<void> getPolyPointsFromBusLocationToStop() async {
    final List<LatLng> locations = [
      LatLng(31.4276475, 73.1239164),
      LatLng(31.4229034, 73.1177229),
      LatLng(31.4212829, 73.1198901),
      LatLng(31.4197253, 73.1222773),
      LatLng(31.4202761, 73.1161345),
      LatLng(31.4159077, 73.1117434),
      LatLng(31.440245896341917, 73.13314553744294), //user's stop
      LatLng(31.610249422487897, 73.03401091367458) //uni location
    ];

    polylineCoordinates2.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    LatLng origin =
    LatLng(busLocation!.latitude!, busLocation!.longitude!);
    locations.sort((a, b) => haversineDistance(
        origin.latitude, origin.longitude, a.latitude, a.longitude)
        .compareTo(haversineDistance(
        origin.latitude, origin.longitude, b.latitude, b.longitude)));

    for (int i = 0; i < locations.length; i++) {
      LatLng destination = locations[i];
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(origin.latitude, origin.longitude),
        PointLatLng(destination.latitude, destination.longitude),
      );
      if (result.points.isNotEmpty) {
        setState(() {
          polylineCoordinates2.addAll(result.points.map(
                  (PointLatLng point) => LatLng(point.latitude, point.longitude)));
          origin = destination;
        });
      } else {
        print("Empty polyline points for route segment $i");
      }
    }
    print("Polyline Coordinates: $polylineCoordinates2");
  }

  double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295; // Math.PI / 180
    double a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    routeNo = args['routeNo'] as int;

    List<Marker> markers = [];
    String markerIdValue = "stop";
    MarkerId markerId = MarkerId(markerIdValue);
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(31.440245896341917, 73.13314553744294),
      infoWindow: InfoWindow(
        title: 'Estimated time',
        snippet: _estimatedTime,
      ),
    );
    markers.add(marker);

    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text('Track Route', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF03314B),
      ),
      body: currentLocation == null || busLocation == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Text('Estimated time for bus to reach stop: $_estimatedTime'),
          Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(currentLocation!.latitude!,
                      currentLocation!.longitude!),
                  zoom: 13.5,
                ),
                markers: {
                  ...markers,
                  Marker(
                    markerId: const MarkerId("currentLocation"),
                    icon: personIcon!,
                    position: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                  ),
                  Marker(
                    markerId: const MarkerId("busLocation"),
                    icon: busIcon!,
                    position: LatLng(
                        busLocation!.latitude!, busLocation!.longitude!),
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("routeUser"),
                    points: polylineCoordinates1,
                    color: Color(0xFF008080), // Change the color as needed
                    width: 6,
                  ),
                  Polyline(
                    polylineId: const PolylineId("routeBus"),
                    points: polylineCoordinates2,
                    // Change this to bus polyline coordinates
                    color: Colors.pink,
                    // Change the color as needed
                    width: 6,
                  ),
                },
              ))
        ],
      ),
    );
  }
}
