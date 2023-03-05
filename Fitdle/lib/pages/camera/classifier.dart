import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class Classifier {
  late Interpreter _interpreter;
  late ImageProcessor imageProcessor;
  late TensorImage inputImage;
  late List<Object> inputs;

  Map<int, Object> outputs = {};
  TensorBuffer outputLocations = TensorBufferFloat([]);

  Stopwatch s = Stopwatch();

  int frameNo = 0;

  Classifier({Interpreter? interpreter}) {
    loadModel(interpreter: interpreter);
  }

  void performOperations(CameraImage cameraImage) {
    s.start();

    image_lib.Image convertedImage = convertCameraImage(cameraImage);
    if (Platform.isAndroid) {
      convertedImage = image_lib.copyRotate(convertedImage, 270);
      convertedImage = image_lib.flipHorizontal(convertedImage);
    }
    inputImage = TensorImage(TfLiteType.float32);
    inputImage.loadImage(convertedImage);
    inputImage = getProcessedImage();

    inputs = [inputImage.buffer];

    s.stop();
    frameNo += 1;

    s.reset();
  }

  static image_lib.Image convertCameraImage(CameraImage cameraImage) {
    if (Platform.isIOS) {
      return image_lib.Image.fromBytes(
        cameraImage.planes[0].bytesPerRow ~/ 4,
        cameraImage.height,
        cameraImage.planes[0].bytes,
        format: image_lib.Format.bgra,
      );
    } else {
      final int width = cameraImage.width;
      final int height = cameraImage.height;

      final int uvRowStride = cameraImage.planes[0].bytesPerRow;
      final int? uvPixelStride = cameraImage.planes[0].bytesPerPixel;

      var image = image_lib.Image(width, height);

      for (int w = 0; w < width; w++) {
        for (int h = 0; h < height; h++) {
          final int uvIndex =
              uvPixelStride! * (w / 2).floor() + uvRowStride * (h / 2).floor();
          final int index = h * width + w;

          final y = cameraImage.planes[0].bytes[index];
          final u = cameraImage.planes[1].bytes[uvIndex];
          final v = cameraImage.planes[2].bytes[uvIndex];

          image.data[index] = yuv2rgb(y, u, v);
        }
      }
      // image = image_lib.copyResize(image, height: 256, width: 256);
      return image;
    }
  }

  static int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    int r = (y + v * 1436 / 1024 - 179).round();
    int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    int b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  TensorImage getProcessedImage() {
    int padSize = max(inputImage.height, inputImage.width);
    imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(256, 256, ResizeMethod.BILINEAR))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  runModel() async {
    Map<int, Object> outputs = {0: outputLocations.buffer};
    interpreter.runForMultipleInputs(inputs, outputs);
  }

  loadModel({Interpreter? interpreter}) async {
    try {
      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            "thunder.tflite",
            options: InterpreterOptions()..threads = 4,
          );
    } catch (e) {
      print("Error while creating interpreter: $e");
    }

    outputLocations = TensorBufferFloat([1, 1, 17, 3]);
  }

  parseLandmarkData() {
    List outputParsed = [];
    List<double> data = outputLocations.getDoubleList();
    List result = [];
    num x, y, c;

    for (var i = 0; i < 51; i += 3) {
      x = (data[1 + i]);
      y = (data[0 + i]);
      c = (data[2 + i]);
      result.add([x, y, c]);
    }
    outputParsed = result;

    // print("\n");
    // printWrapped(outputParsed.toString());
    // print("\n");

    return result;
  }

  Interpreter get interpreter => _interpreter;
}
