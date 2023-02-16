import 'dart:async';
import 'package:camera/camera.dart';
import 'package:fitdle/models/exercise.dart';
import 'package:fitdle/pages/camera/camera_vm.dart';
import 'package:flutter/material.dart';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuple/tuple.dart';
import 'package:fitdle/models/classifier.dart';
import 'package:fitdle/models/isolate.dart';
import 'package:image/image.dart' as imglib;
import 'dart:typed_data';
import 'dart:math';
import 'dart:isolate';

var KEYPOINT_DICT = {
  'nose': 0,
  'left_eye': 1,
  'right_eye': 2,
  'left_ear': 3,
  'right_ear': 4,
  'left_shoulder': 5,
  'right_shoulder': 6,
  'left_elbow': 7,
  'right_elbow': 8,
  'left_wrist': 9,
  'right_wrist': 10,
  'left_hip': 11,
  'right_hip': 12,
  'left_knee': 13,
  'right_knee': 14,
  'left_ankle': 15,
  'right_ankle': 16
};

var EXERCISES = {
  'squat': {
    'name': 'Squat',
    'allowed_err': 15,
    'alert_err': 10,
    'states': [
      {
        ('both_knee,both_hip,both_ankle'): 100,
      },
      {
        ('both_knee,both_hip,both_ankle'): 180,
      }
    ]
  },
  'pushup': {
    'name': 'Pushup',
    'allowed_err': 25,
    'alert_err': 5,
    'states': [
      {
        'both_elbow,both_wrist,both_shoulder': 180,
        'both_hip,both_shoulder,both_ankle': 180,
      },
      {
        'both_elbow,both_wrist,both_shoulder': 90,
        'both_hip,both_shoulder,both_ankle': 180,
      }
    ]
  },
};

class CameraScreen extends StatefulWidget {
  const CameraScreen(
      {Key? key, required this.camera, required this.exerciseType})
      : super(key: key);
  final CameraDescription camera;
  final ExerciseType exerciseType;

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
  late List<dynamic> inferences;
  late IsolateUtils isolate;
  bool isDetecting = false;
  bool initialized = false;

  int state = 0;
  int repCounts = 0;
  List<String> message = [];
  var curr_err = Map();
  late StreamSubscription _navigationSubscription;
  late StreamSubscription _errorSubscription;
  var _isLoading = false;

  @override
  void initState() {
    _initCamera();
    _listen();
    super.initState();
  }

  @override
  void dispose() {
    _camera.dispose();
    _cameraVM.dispose();
    _navigationSubscription.cancel();
    _errorSubscription.cancel();
    super.dispose();
  }

  Tuple2 _getCameraError(String code) {
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
        final error = _getCameraError(e.code);
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

  Map _verify_output(List keypoints_scores, Map expectedPose,
      [double threshold = 0]) {
    var diffs = Map();
    expectedPose.forEach((posture, expectedAngle) {
      List postures = posture.split(',');
      if (postures[0].contains("both")) {
        double angle_r = 99999;
        double angle_l = 99999;
        List<int> p1_r = keypoints_scores[
                KEYPOINT_DICT[postures[0].replaceAll('both', 'right')]!]
            .take(2)
            .toList()
            .cast<int>();
        List<int> p2_r = keypoints_scores[
                KEYPOINT_DICT[postures[1].replaceAll('both', 'right')]!]
            .take(2)
            .toList()
            .cast<int>();
        List<int> p3_r = keypoints_scores[
                KEYPOINT_DICT[postures[2].replaceAll('both', 'right')]!]
            .take(2)
            .toList()
            .cast<int>();
        List<int> p1_l = keypoints_scores[
                KEYPOINT_DICT[postures[0].replaceAll('both', 'left')]!]
            .take(2)
            .toList()
            .cast<int>();
        List<int> p2_l = keypoints_scores[
                KEYPOINT_DICT[postures[1].replaceAll('both', 'left')]!]
            .take(2)
            .toList()
            .cast<int>();
        List<int> p3_l = keypoints_scores[
                KEYPOINT_DICT[postures[2].replaceAll('both', 'left')]!]
            .take(2)
            .toList()
            .cast<int>();

        print("random arr");
        print(p1_r);

        if ((keypoints_scores[
                        KEYPOINT_DICT[postures[0].replaceAll('both', 'right')]!]
                    [2] as double) >
                threshold &&
            (keypoints_scores[
                        KEYPOINT_DICT[postures[1].replaceAll('both', 'right')]!]
                    [2] as double) >
                threshold &&
            (keypoints_scores[
                        KEYPOINT_DICT[postures[2].replaceAll('both', 'right')]!]
                    [2] as double) >
                threshold) {
          angle_r = _angle_between(p2_r, p1_r, p3_r);
        }

        if ((keypoints_scores[
                        KEYPOINT_DICT[postures[0].replaceAll('both', 'left')]!]
                    [2] as double) >
                threshold &&
            (keypoints_scores[
                        KEYPOINT_DICT[postures[1].replaceAll('both', 'left')]!]
                    [2] as double) >
                threshold &&
            (keypoints_scores[
                        KEYPOINT_DICT[postures[2].replaceAll('both', 'left')]!]
                    [2] as double) >
                threshold) {
          angle_l = _angle_between(p2_l, p1_l, p3_l);
        }
        diffs[postures[0]] = min(
            (angle_r - expectedAngle).abs(), (angle_l - expectedAngle).abs());
      } else {
        List<int> p1 = keypoints_scores[KEYPOINT_DICT[postures[0]]!];
        List<int> p2 = keypoints_scores[KEYPOINT_DICT[postures[1]]!];
        List<int> p3 = keypoints_scores[KEYPOINT_DICT[postures[2]]!];
        if (p1[2].toDouble() > threshold &&
            p2[2].toDouble() > threshold &&
            p3[2].toDouble() > threshold) {
          double angle = _angle_between(p2, p1, p3);
          double error = (angle - expectedAngle).abs();
          diffs[postures[0]] = error;
        }
      }
    });
    return diffs;
  }

  double _angle_between(List<int> pointA, List<int> pointB, List<int> pointC) {
    double rad1 = atan2(pointA[0] - pointB[0], pointA[1] - pointB[1]);
    double rad2 = atan2(pointC[0] - pointB[0], pointC[1] - pointB[1]);
    double deg1 = (rad1 * 180 / pi).abs();
    double deg2 = (rad2 * 180 / pi).abs();
    print("angle results");
    print(deg1);
    print(deg2);

    if ((deg2 - deg1).abs() <= 180) {
      return (deg2 - deg1).abs();
    } else {
      return (deg1 - deg2).abs();
    }
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
    });
    // TODO, TEMP VARS, NEED TO CHANGE TO ACTUAL
    final exercise = widget.exerciseType.name;
    int numStates = (EXERCISES[exercise]!['states'] as List).length;
    int allowed_err = EXERCISES[exercise]!['allowed_err'] as int;
    int alert_err = EXERCISES[exercise]!['alert_err'] as int;

    var diffs_curr = _verify_output(
        inferences, (EXERCISES[exercise]!['states'] as List)[state] as Map);
    var diffs_next = _verify_output(
        inferences,
        (EXERCISES[exercise]!['states'] as List)[(state + 1) % numStates]
            as Map);

    print("diffs curr:");
    print(diffs_curr);

    bool best_pose = true;
    // diffs_curr.forEach((k, v) {
    //   // Can't break foreach lol :)

    //   // if (!curr_err.containsKey(k)) {
    //   //   break;
    //   // }
    //   if (!curr_err.containsKey(k) && curr_err[k] < v) {
    //     best_pose = false;
    //     // break;
    //   }
    // });
    for (final k in diffs_curr.keys) {
      if (!curr_err.containsKey(k)) {
        break;
      }
      if (curr_err[k] < diffs_curr[k]) {
        best_pose = false;
        break;
      }
    }

    if (best_pose) {
      curr_err = diffs_curr;
    }

    if (diffs_next.values.every((err) => err < allowed_err)) {
      curr_err.forEach((k, v) {
        if (v > alert_err) {
          message.add(
              "Your form at your ${k.replaceAll('both_', '')} is a bit off");
        }
      });

      setState(() {
        curr_err = {};
        state = (state + 1) % numStates;
      });
      if (state == 0) {
        setState(() {
          repCounts += 1;
        });
      }
    }

    setState(() {
      isDetecting = false;
    });
  }

  Future<List<dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolate.sendPort.send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  Future<void> _finishExercise() async {
    setState(() {
      _isLoading = true;
    });
    await _cameraVM.logStrength(widget.exerciseType);
    setState(() {
      _isLoading = false;
    });
  }

  _listen() {
    _errorSubscription = _cameraVM.error.listen((msg) {
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    });

    _navigationSubscription = _cameraVM.done.listen((value) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (!_camera.value.isInitialized) {
      return Container();
    } else {
      return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 240, 240, 240),
              title: fitdleText(widget.exerciseType.name, h2)),
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
    return Stack(children: [
      Container(
        alignment: Alignment.center,
        child: ClipRect(
          clipper: _MediaSizeClipper(mediaSize),
          child: Stack(alignment: AlignmentDirectional.topCenter, children: [
            Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: CameraPreview(_camera),
            ),
            Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                borderedText(
                  _cameraVM.strengthObject.repetitions.toString(),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                primaryButton("Finish", () => {_finishExercise()}),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                )
              ],
            )
          ]),
        ),
      ),
      if (_isLoading)
        const Center(child: CircularProgressIndicator(color: Colors.purple))
    ]);
  }
}
