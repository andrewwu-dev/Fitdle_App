import 'dart:async';
import 'dart:math';
import 'marker_icon.dart';
import 'run_vm.dart';
import 'stats_display.dart';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:fitdle/models/exercise.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RunScreen extends StatefulWidget {
  const RunScreen({Key? key}) : super(key: key);

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  late final RunVM _runVM;
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

  double totalDistance = 0;
  double totalCalories = 0;
  double totalPace = 0;

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

    final backgroundPermissionGranted =
        await location.isBackgroundModeEnabled();
    if (!backgroundPermissionGranted) {
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: const Text(backgroundPermissionDenied),
                    content: const Text(pleaseSetLocationPermissions),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(ok))
                    ])).then((_) => Navigator.of(context).pop());
      }
    }

    location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 1000, distanceFilter: 2);
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
      LatLng latestPosition =
          polylineCoordinates[polylineCoordinates.length - 1];
      currentLocation = newLoc;
      polylineCoordinates.add(LatLng(newLoc.latitude!, newLoc.longitude!));

      var distance = coordinateDistance(latestPosition.latitude,
          latestPosition.longitude, newLoc.latitude, newLoc.longitude);
      print(distance);
      totalDistance += distance;
      var pace = newLoc.speed ?? 1;
      totalCalories += caloriesBurnt(pace, distance);
      totalPace += pace;
      markers.add(Marker(
          markerId: const MarkerId("current"),
          position: LatLng(newLoc.latitude!, newLoc.longitude!),
          icon: currentMarkerIcon));

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: cameraZoom,
              target: LatLng(newLoc.latitude!, newLoc.longitude!))));
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _runVM = RunVM();

    MarkerGenerator(80)
        .createIcon(
            Icons.directions_run, Colors.purple, Colors.pink, Colors.white)
        .then((icon) => currentMarkerIcon = icon);

    getLocationPermission();
    getStartLocation();
  }

  @override
  void dispose() {
    super.dispose();
    _runVM.dispose();
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
                            children: [
                              StatsDisplay(
                                  value: totalCalories.round().toString(),
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
                              StatsDisplay(
                                  value: totalDistance.toStringAsFixed(2),
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
  }

  buttonPressed() async {
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
        // update runObject and save exercise
        runObject.calories = totalCalories.round();
        runObject.distance = totalDistance;
        runObject.avgPace = totalPace / polylineCoordinates.length;
        runObject.numSteps = ((totalDistance * 1000) / 0.64).round();
        for (final point in polylineCoordinates) {
          runObject.path.add(point.toJson());
        }
        await _runVM.createRunLog(runObject);
        break;
      case done:
        Navigator.pop(context);
        break;
    }
  }

  double coordinateDistance(lat1, lon1, lat2, lon2) {
    const double p = pi / 180;
    const int radiusEarthKm = 6371;
    double a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 2 * radiusEarthKm * asin(sqrt(a)) / 4;
  }

  double caloriesBurnt(double speed, double distance) {
    //  const double kmToM = 0.62137;
    const double lbtokg = 0.45;
    const double b_scale = 0.75;
    double segtime = speed / distance;
    int userweight = 0; //_userRepo.user.bodyWeight;
    return b_scale * userweight * lbtokg * speed * segtime;
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
