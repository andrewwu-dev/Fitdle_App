import 'package:camera/camera.dart';
import 'package:fitdle/pages/camera/camera_vm.dart';
import 'package:flutter/material.dart';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:tuple/tuple.dart';
import 'package:fitdle/models/classifier.dart';
import 'package:fitdle/models/isolate.dart';
import 'package:image/image.dart' as imglib;
import 'dart:typed_data';
import 'dart:math';
import 'dart:isolate';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

// https://stackoverflow.com/questions/56735552/how-to-set-flutter-camerapreview-size-fullscreen
class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const _MediaSizeClipper(this.mediaSize);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _camera;
  late final CameraVM _cameraVM;
  late Classifier classifier;
  late List parsedData;
  late List<dynamic> inferences;
  late IsolateUtils isolate;
  bool isDetecting = false;
  bool initialized = false;

  // TEST VARIABLES
  double test_angle1 = 0;
  double test_angle2 = 0;

   // WORKOUT AND WEEK DATA
  // late JsonHandler jsonHandler;
  late List<dynamic> exercise;
  late String workout;
  late var dayToday;

  // DAY WORKOUT VARIABLES
  late var handler;

  int workoutIndex = 0;
  String exerciseName = "";
  String exerciseDisplayName = "";
  String imgUrl = "";
  int reps = 0;
  int sets = 0;

  int doneReps = 0;
  int doneSets = 0;
  var stage = "up";
  bool rest = false;
  int restTime = 0;

  // POSE AND FORM VALIDATION
  bool isProperForm = false;
  List<dynamic> limbs = [];
  List<dynamic> targets = [];

  // HAS WORKOUTS TODAY
  bool hasWorkoutsToday = false;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  Tuple2 getCameraError(String code) {
    switch (code) {
      case "CameraAccessDenied":
        return const Tuple2(cameraAccessDenied, pleaseGrantCameraAccess);
      case "CameraAccessDeniedWithoutPrompt":
        return const Tuple2(cameraAccessDenied, goToSettingsCamera);
      case "AudioAccessDenied":
        return const Tuple2(audioAccessDenied, pleaseGrantAudioAccess);
      case "AudioAccessDeniedWithoutPrompt":
        return const Tuple2(audioAccessDenied, goToSettingsMicrophone);
      default:
        return const Tuple2(cameraNotFound, pleaseGrantCameraAccess);
    }
  }

  void _initCamera() async {
    isolate = IsolateUtils();
    await isolate.start();
    classifier = Classifier();
    classifier.loadModel();
    _cameraVM = CameraVM();
    _camera = CameraController(widget.camera, ResolutionPreset.max);
    await _camera.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      _camera.startImageStream((CameraImage image) {
        createIsolate(image);
        // process image/frame here
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        final error = getCameraError(e.code);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Text(error.item1),
                    content: Text(error.item2),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(ok))
                    ]));
      }
    });
  }

  double getAngle(List<int> pointA, List<int> pointB, List<int> pointC) {
    double radians = atan2(pointC[1] - pointB[1], pointC[0] - pointB[0]) -
        atan2(pointA[1] - pointB[1], pointA[0] - pointB[0]);
    double angle = (radians * 180 / pi).abs();

    if (angle > 180) {
      angle = 360 - angle;
    }

    return angle;
  }


  void createIsolate(CameraImage imageStream) async {
    if (isDetecting == true) {
      return;
    }

    setState(() {
      isDetecting = true;
    });

    var isolateData = IsolateData(imageStream, classifier.interpreter.address);
    List<dynamic> inferenceResults = await inference(isolateData);
    print("inference results");
    print(inferenceResults);

    setState(() {
      inferences = inferenceResults;
      isDetecting = false;
      initialized = true;

      List<int> pointA = [inferenceResults[7][0], inferenceResults[7][1]];
      List<int> pointB = [inferenceResults[5][0], inferenceResults[5][1]];
      List<int> pointC = [inferenceResults[11][0], inferenceResults[11][1]];
      test_angle2 = getAngle(pointA, pointB, pointC);

      int limbsIndex = 0;

      //   if (!rest) {
      //     if (doneSets < sets) {
      //       if (doneReps < reps) {
      //         checkLimbs(inferenceResults, limbsIndex);
      //         isProperForm = isPostureCorrect();
      //         doReps(inferenceResults);
      //       } else {
      //         setState(() {
      //           doneReps = 0;
      //           doneSets++;
      //           rest = true;
      //           restTime = 30;
      //         });
      //       }
      //     } else {
      //       setState(() {
      //         doneSets = 0;
      //         doneReps = 0;
      //         nextWorkout();
      //         rest = true;
      //         restTime = 60;
      //       });
      //     }
      //   } else {
      //     setState(() {
      //       restTime = 0;
      //       rest = false;
      //     });
      //   }
      // });

      // if (!rest) {
      //   if (handler.doneSets < sets) {
      //     if (handler.doneReps < reps) {
      //       handler.checkLimbs(inferenceResults, limbsIndex);
      //       isProperForm = handler.isPostureCorrect();
      //       handler.doReps(inferenceResults);
      //       setState(() {
      //         doneReps = handler.doneReps;
      //         stage = handler.stage;
      //         test_angle1 = handler.angle;
      //       });
      //     } else {
      //       handler.doneReps = 0;
      //       handler.doneSets++;
      //       setState(() {
      //         doneReps = handler.doneReps;
      //         doneSets = handler.doneSets;
      //         rest = true;
      //         restTime = 30;
      //       });
      //     }
      //   } else {
      //     handler.doneSets = 0;
      //     handler.doneReps = 0;
      //     setState(() {
      //       doneReps = handler.doneReps;
      //       doneSets = handler.doneSets;
      //       nextWorkout();
      //       rest = true;
      //       restTime = 60;
      //     });
      //   }
      // } else {
      //   setState(() {
      //     restTime = 0;
      //     rest = false;
      //   });
      // }
    });
  }
  
  Future<List<dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolate.sendPort.send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  @override
  void dispose() {
    _camera.dispose();
    _cameraVM.dispose();
    super.dispose();
  }

  double getCameraScale(Size size) {
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cameraScale = getCameraScale(size);

    if (!_camera.value.isInitialized) {
      return Container();
    } else {
      final header = ModalRoute.of(context)!.settings.arguments as String;
      return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 240, 240, 240),
              title: fitdleText(header, h2)),
          body: body(size));
    }
  }

  // https://stackoverflow.com/questions/52146269/how-to-decorate-text-stroke-in-flutter
  Widget borderedText(String text) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: TextStyle(
            fontSize: h2,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = Colors.black,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: const TextStyle(
            fontSize: h2,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget body(Size size) {
    final mediaSize = MediaQuery.of(context).size;
    final scale = 1 / (_camera.value.aspectRatio * mediaSize.aspectRatio);
    return Container(
        alignment: Alignment.center,
        child: ClipRect(
            clipper: _MediaSizeClipper(mediaSize),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Transform.scale(
                  scale: scale,
                  alignment: Alignment.topCenter,
                  child: CameraPreview(_camera),
                ),
                Column(
                  verticalDirection: VerticalDirection.down,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    borderedText("4 reps"),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                    primaryButton(
                        "Finish", () => {Navigator.of(context).pop()}),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10))
                  ],
                )
              ],
            )));
  }
}
