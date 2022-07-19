import 'dart:async';
import 'marker_icon.dart';
import 'package:fitdle/auth/secrets.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RunScreen extends StatefulWidget {
  const RunScreen({Key? key}) : super(key: key);

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng startLocation;
  late LatLng endLocation;
  late StreamSubscription locationSubscription;

  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor currentMarkerIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();
    location.enableBackgroundMode(enable: true);

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

    location.getLocation().then((loc) {
      startLocation = LatLng(loc.latitude!, loc.longitude!);
      markers.add(Marker(
          markerId: const MarkerId("start"),
          position: startLocation,
          icon: BitmapDescriptor.defaultMarker));

      currentLocation = loc;
      polylineCoordinates.add(LatLng(loc.latitude!, loc.longitude!));
      setState(() {});
    });

    GoogleMapController googleMapController = await _controller.future;

    locationSubscription = location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      polylineCoordinates.add(LatLng(newLoc.latitude!, newLoc.longitude!));
      markers.add(Marker(
          markerId: const MarkerId("current"),
          position: LatLng(newLoc.latitude!, newLoc.longitude!),
          icon: currentMarkerIcon));

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 15, target: LatLng(newLoc.latitude!, newLoc.longitude!))));
      setState(() {});
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapsKey,
        PointLatLng(startLocation.latitude, startLocation.longitude),
        PointLatLng(endLocation.latitude, endLocation.longitude),
        travelMode: TravelMode.walking);

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    MarkerGenerator(80).createIcon(
      Icons.directions_run,
      Colors.purple,
      Colors.pink,
      Colors.white
    ).then((icon) => currentMarkerIcon = icon);

    getCurrentLocation();
    //getPolyPoints();
  }

  @override
  void dispose() {
    super.dispose();
    locationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        title: const Text(
          run,
          style: TextStyle(
              fontFamily: 'Roboto', fontSize: h2, color: Colors.black),
        ),
      ),
      body: currentLocation == null
          ? const Center(
              child: Text("Loading",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: body)))
          : Container(
              color: const Color.fromARGB(255, 240, 240, 240),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(startLocation.latitude,
                        startLocation.longitude),
                    zoom: 15),
                polylines: {
                  Polyline(
                      polylineId: const PolylineId("route"),
                      points: polylineCoordinates,
                      color: Colors.purple,
                      width: 6)
                },
                markers: markers,
                onMapCreated: (mapController) {
                  _controller.complete(mapController);
                },
              )),
    );
  }
}
