import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ontrack/dbHelper/mongodb.dart';

class TrackRoute extends StatefulWidget {
  const TrackRoute({super.key});

  @override
  State<TrackRoute> createState() => _TrackRouteState();
}

class _TrackRouteState extends State<TrackRoute> {
  int? routeNo;
  LatLng? stopCoords2;
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;
  LocationData? busLocation;
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
      stopCoords2!.latitude!,
      stopCoords2!.longitude!,
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
      if (routeNo != null && stopCoords2 !=null) {
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
    stopCoords2=args['stopCoords'] as LatLng;
    LatLng stopCoords = args['stopCoords'] as LatLng;
    List<Marker> markers = [];
    String markerIdValue = "stop";
    MarkerId markerId = MarkerId(markerIdValue);
    Marker marker = Marker(
      markerId: markerId,
      position: stopCoords,
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
                ))
              ],
            ),
    );
  }
}
