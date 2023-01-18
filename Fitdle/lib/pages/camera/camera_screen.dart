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
  late CameraController _controller;
  late final CameraVM _cameraVM;

  @override
  void initState() {
    super.initState();
    _cameraVM = CameraVM();

    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _cameraVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
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
              child:  CameraPreview(_controller)
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
