import 'package:camera/camera.dart';
import 'package:fitdle/pages/camera/camera_vm.dart';
import 'package:flutter/material.dart';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';

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

  void _initCamera() async {
    _cameraVM = CameraVM();
    _camera = CameraController(widget.camera, ResolutionPreset.max);
    await _camera.initialize();
    setState(() {});
    _camera.startImageStream((CameraImage image) {
        // process image/frame here
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
