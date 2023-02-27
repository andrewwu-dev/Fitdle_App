import 'package:fitdle/constants/exercise_positions.dart';
import 'package:flutter/material.dart';

class CameraScreenPainter extends CustomPainter {
  // 2d array of [x, y, score] for each keypoint
  final List? _inferences;
  late Paint _paint;
  late double _threshold;
  final double? _cameraHeight, _cameraWidth;

  CameraScreenPainter(this._inferences, this._cameraHeight, this._cameraWidth) {
    _paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    _threshold = 0.3;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_inferences == null || _cameraHeight == null || _cameraWidth == null) {
      return;
    }

    for (var edgePair in keyPointsEdgeIndsToColor.keys) {
      final point1 = _cameraPointToScreenPoint(
          _inferences![edgePair[0]][0], _inferences![edgePair[0]][1], size);
      final point2 = _cameraPointToScreenPoint(
          _inferences![edgePair[1]][0], _inferences![edgePair[1]][1], size);
      final confidence1 = _inferences![edgePair[0]][2] >= _threshold;
      final confidence2 = _inferences![edgePair[1]][2] >= _threshold;

      if (_inferences![edgePair[0]][3] == 0.0 ||
          _inferences![edgePair[1]][3] == 0.0) {
        _paint.color = Colors.red;
      } else {
        _paint.color = Colors.green;
      }

      if (confidence1 && confidence2) {
        canvas.drawLine(point1, point2, _paint);
        canvas.drawCircle(point1, 6.0, _paint);
        canvas.drawCircle(point2, 6.0, _paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Offset _cameraPointToScreenPoint(
      double inferenceX, double inferenceY, Size size) {
    var scaleW, scaleH, newX, newY;
    if (size.height / size.width > _cameraHeight! / _cameraWidth!) {
      scaleW = size.height / _cameraHeight! * _cameraWidth!;
      scaleH = size.height;
      final difW = (scaleW - size.width) / scaleW;
      newX = (inferenceX - difW / 2) * scaleW;
      newY = inferenceY * scaleH;
    } else {
      scaleW = size.width;
      scaleH = size.width / _cameraWidth! * _cameraHeight!;
      final difH = (scaleH - size.height) / scaleH;
      newX = inferenceX * scaleW;
      newY = (inferenceY - difH / 2) * scaleH;
    }
    return Offset(newX, newY);
  }
}
