import 'dart:async';
import 'marker_icon.dart';
import 'stats_display.dart';
import 'package:fitdle/auth/secrets.dart';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:flutter/material.dart';
import 'package:fitdle/pages/run/run_vm.dart';
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
  late RunObject runObject;
  late Stream<int> timerStream;
  late StreamSubscription<int> timerSubscription;
  late StreamSubscription locationSubscription;

  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  Location location = Location();
  BitmapDescriptor currentMarkerIcon = BitmapDescriptor.defaultMarker;

  String buttonState = startRun;
  String minutes = "00";
  String seconds = "00";
  double cameraZoom = 16;

  void getLocationPermission() async {
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

    location.changeSettings(accuracy: LocationAccuracy.high, interval: 1000, distanceFilter: 0);
    location.enableBackgroundMode(enable: true);
  }

  void getStartLocation() {
    location.getLocation().then((loc) {
      // LocationData has some interesting properties like timestamp, speed, accuracy, and altitude
      startLocation = LatLng(loc.latitude!, loc.longitude!);
      markers.add(Marker(
          markerId: const MarkerId("start"),
          position: startLocation,
          icon: BitmapDescriptor.defaultMarker));

      currentLocation = loc;
      polylineCoordinates.add(LatLng(loc.latitude!, loc.longitude!));
      setState(() {});
    });
  }

  void updateCurrentLocation() async {
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
              zoom: cameraZoom, target: LatLng(newLoc.latitude!, newLoc.longitude!))));
      setState(() {});
    });
  }

  // void getPolyPoints() async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       googleMapsKey,
  //       PointLatLng(startLocation.latitude, startLocation.longitude),
  //       PointLatLng(endLocation.latitude, endLocation.longitude),
  //       travelMode: TravelMode.walking);

  //   if (result.points.isNotEmpty) {
  //     for (var point in result.points) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     }
  //     setState(() {});
  //   }
  // }

  @override
  void initState() {
    super.initState();

    MarkerGenerator(80)
        .createIcon(
            Icons.directions_run, Colors.purple, Colors.pink, Colors.white)
        .then((icon) => currentMarkerIcon = icon);

    getLocationPermission();
    getStartLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            backgroundColor: const Color.fromARGB(255, 240, 240, 240),
            title: fitdleText(run, h2)),
        body: currentLocation == null
            ? Center(child: fitdleText(loading, body))
            // : WillPopScope(
            //   onWillPop: () async => false,
            //   child:
            : Container(
                color: const Color.fromARGB(255, 240, 240, 240),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      height: size.height / 2.5,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(startLocation.latitude,
                                startLocation.longitude),
                            zoom: cameraZoom),
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
                      ),
                    ),
                    const Divider(
                        height: 10, thickness: 1, color: Colors.black),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              StatsDisplay(
                                  value: "150",
                                  label: calories,
                                  valueFontSize: h1,
                                  labelFontSize: h4),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StatsDisplay(
                                  value: "$minutes:$seconds",
                                  label: timeFormat,
                                  valueFontSize: h2,
                                  labelFontSize: h4),
                              const StatsDisplay(
                                  value: "3.00",
                                  label: distance,
                                  valueFontSize: h2,
                                  labelFontSize: h4),
                            ]),
                        primaryButton(
                            buttonState == startRun
                                ? startRun
                                : buttonState == stopRun
                                    ? stopRun
                                    : done,
                            buttonPressed)
                      ],
                    ))
                  ],
                )));
    //);
  }

  buttonPressed() {
    switch (buttonState) {
      case startRun:
        updateCurrentLocation();
        timerStream = stopWatchStream();
        timerSubscription = timerStream.listen((int newTick) {
          setState(() {
            minutes = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
            seconds = (newTick % 60).floor().toString().padLeft(2, '0');
          });
        });
        setState(() {
          buttonState = stopRun;
        });
        break;
      case stopRun:
        setState(() {
          buttonState = done;
        });
        timerSubscription.cancel();
        locationSubscription.cancel();
        endLocation =
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
        MarkerGenerator(80)
            .createIcon(Icons.flag, Colors.purple, Colors.pink, Colors.white)
            .then((icon) {
          markers.clear();
          markers.add(Marker(
              markerId: const MarkerId("start"),
              position: startLocation,
              icon: BitmapDescriptor.defaultMarker));
          markers.add(Marker(
              markerId: const MarkerId("end"),
              position: endLocation,
              icon: icon));
        });
        setState(() {});
        // TODO: update runObject and save exercise
        break;
      case done:
        Navigator.popAndPushNamed(context, "dashboard");
        break;
    }
  }

  Stream<int> stopWatchStream() {
    late StreamController<int> streamController;
    late Timer timer;
    Duration timerInterval = const Duration(seconds: 1);

    void stopTimer() {
      timer.cancel();
      runObject.endTime = DateTime.now();
      streamController.close();
    }

    void tick(Timer timer) {
      streamController.add(timer.tick);
      if (buttonState == done) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
      timer.tick;
      runObject = RunObject(DateTime.now());
    }

    streamController =
        StreamController<int>(onListen: startTimer, onCancel: stopTimer);

    return streamController.stream;
  }
}
