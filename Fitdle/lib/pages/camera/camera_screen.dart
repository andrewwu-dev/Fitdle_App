import 'dart:async';
import 'package:camera/camera.dart';
import 'package:fitdle/models/exercise.dart';
import 'package:fitdle/pages/camera/camera_vm.dart';
import 'package:flutter/material.dart';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuple/tuple.dart';

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

  late StreamSubscription _navigationSubscription;
  late StreamSubscription _errorSubscription;
  var _isLoading = false;
  var _isAnalyzing = false;

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
    _cameraVM = CameraVM();
    _camera = CameraController(widget.camera, ResolutionPreset.max);
    await _camera.initialize().then((_) {
      if (!mounted) {
        // May need to pop camera screen here
        return;
      }
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
    await _cameraVM.initIsolate();
    setState(() {});
    _camera.startImageStream((CameraImage image) {
      _createIsolate(image);
    });
  }

  void _createIsolate(CameraImage imageStream) async {
      if(_isAnalyzing){
        return;
      }
      setState(() {
        _isAnalyzing = true;
      });
    await _cameraVM.createIsolate(imageStream, widget.exerciseType);
      setState(() {
        _isAnalyzing = false;
      });
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
