import 'package:camera/camera.dart';
import 'package:fitdle/pages/camera/camera_vm.dart';
import 'package:flutter/cupertino.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.camera}) : super(key: key);
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
      return CameraPreview(_controller);
    }
  }
}
