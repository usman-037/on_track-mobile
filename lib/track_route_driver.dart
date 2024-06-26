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
  BitmapDescriptor? driverIcon;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getCurrentLocation();
    });
    setCustomMarker();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {});
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
    List<LatLng> latLngList = args['latlngList'] as List<LatLng>;
    List<Marker> markers = [];

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
            ),
    );
  }
}
