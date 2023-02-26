import 'dart:math';
import 'package:fitdle/constants/exercise_positions.dart';

class PoseEstimation {
  Map verifyOutput(List keypointScores, Map expectedPose,
      [double threshold = 0.3]) {
    var diffs = {};
    expectedPose.forEach((posture, expectedAngle) {
      List postures = posture.split(',');
      if (postures[0].contains("both")) {
        double angleR = 99999;
        double angleL = 99999;
        List<double> p1R = keypointScores[
                keyPointDict[postures[0].replaceAll('both', 'right')]!]
            .take(2)
            .toList()
            .cast<double>();
        List<double> p2R = keypointScores[
                keyPointDict[postures[1].replaceAll('both', 'right')]!]
            .take(2)
            .toList()
            .cast<double>();
        List<double> p3R = keypointScores[
                keyPointDict[postures[2].replaceAll('both', 'right')]!]
            .take(2)
            .toList()
            .cast<double>();
        List<double> p1L = keypointScores[
                keyPointDict[postures[0].replaceAll('both', 'left')]!]
            .take(2)
            .toList()
            .cast<double>();
        List<double> p2L = keypointScores[
                keyPointDict[postures[1].replaceAll('both', 'left')]!]
            .take(2)
            .toList()
            .cast<double>();
        List<double> p3L = keypointScores[
                keyPointDict[postures[2].replaceAll('both', 'left')]!]
            .take(2)
            .toList()
            .cast<double>();

        if ((keypointScores[
                        keyPointDict[postures[0].replaceAll('both', 'right')]!]
                    [2] as double) >
                threshold &&
            (keypointScores[
                        keyPointDict[postures[1].replaceAll('both', 'right')]!]
                    [2] as double) >
                threshold &&
            (keypointScores[
                        keyPointDict[postures[2].replaceAll('both', 'right')]!]
                    [2] as double) >
                threshold) {
          angleR = angleBetween(p2R, p1R, p3R);
        }

        if ((keypointScores[
                        keyPointDict[postures[0].replaceAll('both', 'left')]!]
                    [2] as double) >
                threshold &&
            (keypointScores[
                        keyPointDict[postures[1].replaceAll('both', 'left')]!]
                    [2] as double) >
                threshold &&
            (keypointScores[
                        keyPointDict[postures[2].replaceAll('both', 'left')]!]
                    [2] as double) >
                threshold) {
          angleL = angleBetween(p2L, p1L, p3L);
        }
        diffs[postures[0]] =
            min((angleR - expectedAngle).abs(), (angleL - expectedAngle).abs());
      } else {
        List<double> p1 = keypointScores[keyPointDict[postures[0]]!]
            .take(2)
            .toList()
            .cast<double>();
        List<double> p2 = keypointScores[keyPointDict[postures[1]]!]
            .take(2)
            .toList()
            .cast<double>();
        List<double> p3 = keypointScores[keyPointDict[postures[2]]!]
            .take(2)
            .toList()
            .cast<double>();
        if ((keypointScores[keyPointDict[postures[0]]!]
                    [2] as double) >
                threshold &&
            (keypointScores[keyPointDict[postures[1]]!][2] as double) >
                threshold &&
            (keypointScores[keyPointDict[postures[2]]!][2] as double) >
                threshold) {
          double angle = angleBetween(p2, p1, p3);
          double error = (angle - expectedAngle).abs();
          diffs[postures[0]] = error;
        }
      }
    });
    return diffs;
  }

  double angleBetween(
      List<double> pointA, List<double> pointB, List<double> pointC) {
    double rad1 = atan2(pointA[0] - pointB[0], pointA[1] - pointB[1]);
    double rad2 = atan2(pointC[0] - pointB[0], pointC[1] - pointB[1]);
    double deg1 = (rad1 * 180 / pi).abs();
    double deg2 = (rad2 * 180 / pi).abs();

    if ((deg2 - deg1).abs() <= 180) {
      return (deg2 - deg1).abs();
    } else {
      return (deg1 - deg2).abs();
    }
  }
}
