import 'package:camera/camera.dart';
import 'package:fitdle/pages/camera/camera_vm.dart';
import 'package:flutter/material.dart';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:tuple/tuple.dart';

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
    _cameraVM = CameraVM();
    _camera = CameraController(widget.camera, ResolutionPreset.max);
    await _camera.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      _camera.startImageStream((CameraImage image) {
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
