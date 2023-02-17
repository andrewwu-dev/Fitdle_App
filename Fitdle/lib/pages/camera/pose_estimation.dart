import 'dart:math';
import 'package:fitdle/constants/exercise_positions.dart';

class PoseEstimation {
  Map verifyOutput(List keypointScores, Map expectedPose,
      [double threshold = 0]) {
    var diffs = {};
    expectedPose.forEach((posture, expectedAngle) {
      List postures = posture.split(',');
      if (postures[0].contains("both")) {
        double angle_r = 99999;
        double angle_l = 99999;
        List<int> p1_r = keypointScores[
                KEYPOINT_DICT[postures[0].replaceAll('both', 'right')]!]
            .take(2)
            .toList()
            .cast<int>();
        List<int> p2_r = keypointScores[
                KEYPOINT_DICT[postures[1].replaceAll('both', 'right')]!]
            .take(2)
            .toList()
            .cast<int>();
        List<int> p3_r = keypointScores[
                KEYPOINT_DICT[postures[2].replaceAll('both', 'right')]!]
            .take(2)
            .toList()
            .cast<int>();
        List<int> p1_l = keypointScores[
                KEYPOINT_DICT[postures[0].replaceAll('both', 'left')]!]
            .take(2)
            .toList()
            .cast<int>();
        List<int> p2_l = keypointScores[
                KEYPOINT_DICT[postures[1].replaceAll('both', 'left')]!]
            .take(2)
            .toList()
            .cast<int>();
        List<int> p3_l = keypointScores[
                KEYPOINT_DICT[postures[2].replaceAll('both', 'left')]!]
            .take(2)
            .toList()
            .cast<int>();

        print("random arr");
        print(p1_r);

        if ((keypointScores[
                        KEYPOINT_DICT[postures[0].replaceAll('both', 'right')]!]
                    [2] as double) >
                threshold &&
            (keypointScores[
                        KEYPOINT_DICT[postures[1].replaceAll('both', 'right')]!]
                    [2] as double) >
                threshold &&
            (keypointScores[
                        KEYPOINT_DICT[postures[2].replaceAll('both', 'right')]!]
                    [2] as double) >
                threshold) {
          angle_r = angleBetween(p2_r, p1_r, p3_r);
        }

        if ((keypointScores[
                        KEYPOINT_DICT[postures[0].replaceAll('both', 'left')]!]
                    [2] as double) >
                threshold &&
            (keypointScores[
                        KEYPOINT_DICT[postures[1].replaceAll('both', 'left')]!]
                    [2] as double) >
                threshold &&
            (keypointScores[
                        KEYPOINT_DICT[postures[2].replaceAll('both', 'left')]!]
                    [2] as double) >
                threshold) {
          angle_l = angleBetween(p2_l, p1_l, p3_l);
        }
        diffs[postures[0]] = min(
            (angle_r - expectedAngle).abs(), (angle_l - expectedAngle).abs());
      } else {
        List<int> p1 = keypointScores[KEYPOINT_DICT[postures[0]]!];
        List<int> p2 = keypointScores[KEYPOINT_DICT[postures[1]]!];
        List<int> p3 = keypointScores[KEYPOINT_DICT[postures[2]]!];
        if (p1[2].toDouble() > threshold &&
            p2[2].toDouble() > threshold &&
            p3[2].toDouble() > threshold) {
          double angle = angleBetween(p2, p1, p3);
          double error = (angle - expectedAngle).abs();
          diffs[postures[0]] = error;
        }
      }
    });
    return diffs;
  }

  double angleBetween(List<int> pointA, List<int> pointB, List<int> pointC) {
    double rad1 = atan2(pointA[0] - pointB[0], pointA[1] - pointB[1]);
    double rad2 = atan2(pointC[0] - pointB[0], pointC[1] - pointB[1]);
    double deg1 = (rad1 * 180 / pi).abs();
    double deg2 = (rad2 * 180 / pi).abs();
    print("angle results");
    print(deg1);
    print(deg2);

    if ((deg2 - deg1).abs() <= 180) {
      return (deg2 - deg1).abs();
    } else {
      return (deg1 - deg2).abs();
    }
  }
}
