import 'dart:isolate';

import 'package:camera/camera.dart';
import 'classifier.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class IsolateUtils {
  static const String DEBUG_NAME = "InferenceIsolate";
  final ReceivePort _receivePort = ReceivePort();
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateData isolateData in port) {
      Classifier classifier = Classifier(
          interpreter: Interpreter.fromAddress(isolateData.interpreterAddress));
      classifier.performOperations(isolateData.cameraImage);
      classifier.runModel();
      List<dynamic> results = classifier.parseLandmarkData();
      print(results);
      isolateData.responsePort.send(results);
    }
  }
}

/// Bundles data to pass between Isolate
class IsolateData {
  CameraImage cameraImage;
  int interpreterAddress;
  late SendPort responsePort;

  IsolateData(this.cameraImage, this.interpreterAddress);
}
