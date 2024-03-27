import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ontrack/dbHelper/constant.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class TrackRouteDriver extends StatefulWidget {
  const TrackRouteDriver({Key? key}) : super(key: key);

  @override
  State<TrackRouteDriver> createState() => TrackRouteDriverState();
}

class TrackRouteDriverState extends State<TrackRouteDriver> {
  int? routeNo;
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;
  List<LatLng> polylineCoordinates = [];
  BitmapDescriptor? driverIcon;
  final List<LatLng> latLngList = [
    LatLng(31.4276475, 73.1239164),
    LatLng(31.4229034, 73.1177229),
    LatLng(31.4212829, 73.1198901),
    LatLng(31.4197253, 73.1222773),
    LatLng(31.4202761, 73.1161345),
    LatLng(31.4159077, 73.1117434),
    LatLng(31.440245896341917, 73.13314553744294),
    LatLng(31.610249422487897, 73.03401091367458) //uni location
  ];
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getCurrentLocation();
    });
    setCustomMarker();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (routeNo != null) {
        getPolyPoints();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void setCustomMarker() async {
    driverIcon = await BitmapDescriptor.fromAssetImage(
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

    location.onLocationChanged.listen((LocationData newLoc) async {
      setState(() {
        currentLocation = newLoc;
        MongoDatabase.sendLocationToMongoDB(newLoc, routeNo);
      });

    });
  }

  Future<void> getPolyPoints() async {
    polylineCoordinates.clear();
    List<LatLng> locations = latLngList;
    PolylinePoints polylinePoints = PolylinePoints();
    LatLng origin =
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    locations.sort((a, b) =>
        haversineDistance(origin.latitude, origin.longitude, a.latitude,
            a.longitude)
            .compareTo(haversineDistance(origin.latitude, origin.longitude,
            b.latitude, b.longitude)));
    for (int i = 0; i < locations.length; i++) {
      LatLng destination = locations[i];
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(origin.latitude, origin.longitude),
        PointLatLng(destination.latitude, destination.longitude),
      );
      if (result.points.isNotEmpty) {
        setState(() {
          polylineCoordinates.addAll(result.points.map(
              (PointLatLng point) => LatLng(point.latitude, point.longitude)));
          origin = destination;
        });
      } else {
        print("Empty polyline points for route segment $i");
      }
    }
    print("Polyline Coordinates: $polylineCoordinates");
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
    // final latLngList = args['latlngList'] as List<LatLng>;
    routeNo = args['routeNo'] as int;

    List<Marker> markers = [];
    // for (int i = 0; i < latLngList.length; i++) {
    //   LatLng location = latLngList[i];
    //   String markerIdValue = "stop_$i";
    //
    //   MarkerId markerId = MarkerId(markerIdValue);
    //   Marker marker = Marker(
    //     markerId: markerId,
    //     position: location,
    //   );
    //   markers.add(marker);
    // }

    for (int i = 0; i < latLngList.length; i++) {
      LatLng location = latLngList[i];
      String markerIdValue = "stop_$i";

      MarkerId markerId = MarkerId(markerIdValue);
      Marker marker = Marker(
        markerId: markerId,
        position: location,
      );
      markers.add(marker);
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text('Track Route', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF03314B),
      ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 13.5,
              ),
              markers: {
                ...markers,
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  icon: driverIcon!,
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                // getPolyPoints();
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  color: const Color(0xFF7B61FF),
                  width: 6,
                ),
              },
            ),
    );
  }
}
