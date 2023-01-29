import 'package:camera/camera.dart';
import 'package:fitdle/pages/camera/camera_vm.dart';
import 'package:flutter/material.dart';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:tuple/tuple.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.camera})
    : super(key: key);
  final CameraDescription camera;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _camera;
  late final CameraVM _cameraVM;

  @override
  void initState() {
    super.initState();
    _initCamera();
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
        showDialog(context: context, builder: (context) => AlertDialog(
              title: Text(error.item1),
              content: Text(error.item2),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(ok))
              ]
            ));
      }
    });
  }

  @override
  void dispose() {
    _camera.dispose();
    _cameraVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        body: body()
      );
    }
  }

  Widget body() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 7,
              child:  CameraPreview(_camera)
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(left: regular, right: regular),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // TODO: connect this to viewmodel
                    fitdleText("4/10 reps", h2),
                    primaryButton("Finish", () => { Navigator.of(context).pop() })
                  ],
                ),
              ),
            )
          ]
        );
  }
}
