import 'package:camera/camera.dart';
import 'package:fitdle/locator.dart';
import 'package:fitdle/pages/camera/pose_estimation.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/models/earning.dart';
import 'package:fitdle/repository/exercise_repository.dart';
import 'package:fitdle/repository/rewards_repository.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:fitdle/models/exercise.dart';
import 'package:rxdart/rxdart.dart';
import 'classifier.dart';
import 'package:fitdle/pages/camera/isolate.dart';
import 'dart:isolate';
import 'package:fitdle/constants/exercise_positions.dart';

class CameraVM extends ChangeNotifier {
  late final ExerciseRepository _exerciseRepo;
  late final RewardsRepository _rewardsRepo;
  late final UserRepository _userRepo;
  final StrengthObject _strenghtObject = StrengthObject(DateTime.now());
  final PoseEstimation poseEstimation = PoseEstimation();

  final PublishSubject<String> _error = PublishSubject();
  final PublishSubject _done = PublishSubject();

  PublishSubject<String> get error => _error;
  PublishSubject get done => _done;
  StrengthObject get strengthObject => _strenghtObject;

  late Classifier classifier;
  List<dynamic> inferences = [];
  late IsolateUtils isolate;

  int state = 0;
  List<String> message = [];
  var currErr = {};

  CameraVM([userRepo, exerciseRepo, rewardsRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
    _rewardsRepo = rewardsRepo ?? locator.get<RewardsRepository>();
    _exerciseRepo = exerciseRepo ?? locator.get<ExerciseRepository>();
    // TODO: Only used to test right now, replace with actual pose estimation.
    _strenghtObject.repetitions = 5;
  }

  initIsolate() async {
    isolate = IsolateUtils();
    await isolate.start();
    classifier = Classifier();
    classifier.loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    _error.close();
    _done.close();
  }

  updateRepetitions() {
    // TODO: Connect with pose estimation
    _strenghtObject.repetitions += 1;
  }

  _calculateScore() {
    // TODO: Figure out how to calculate score based on exercise?
    const pointsPerRep = 10.0;
    _strenghtObject.score = pointsPerRep * _strenghtObject.repetitions;
  }

  Future<void> logStrength(ExerciseType type) async {
    if (_userRepo.user.id == null) return;
    _strenghtObject.endTimestamp = DateTime.now();
    // +1 because the enum starts at 0, but the API expects 1.
    _strenghtObject.exerciseType = type.index + 1;
    _calculateScore();
    var res = await _exerciseRepo.logStrength(
      _userRepo.user.id!,
      _strenghtObject,
    );
    if (res is Failure) {
      _error.sink.add("Unable to save exercise data");
      return;
    }
    res = await _rewardsRepo.savePoints(
      _userRepo.user.id!,
      Earning(
        _userRepo.user.id!,
        DateTime.now().toIso8601String(),
        _strenghtObject.getPoints(),
      ),
    );
    if (res is Failure) {
      _error.sink.add("Unable to save points");
      return;
    }
    _done.sink.add(null);
  }

  Future<List<dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolate.sendPort.send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  Future<List<dynamic>> createIsolate(
      CameraImage imageStream, ExerciseType exerciseType) async {
    var isolateData = IsolateData(imageStream, classifier.interpreter.address);
    List<dynamic> inferenceResults = await inference(isolateData);
    inferences = inferenceResults;

    final exercise = exerciseType.name;
    int numStates = (exercises[exercise]!['states'] as List).length;
    int allowedErr = exercises[exercise]!['allowed_err'] as int;
    // int alertErr = exercises[exercise]!['alert_err'] as int;

    var diffsCurr = poseEstimation.verifyOutput(
        inferences, (exercises[exercise]!['states'] as List)[state] as Map);
    var diffsNext = poseEstimation.verifyOutput(
        inferences,
        (exercises[exercise]!['states'] as List)[(state + 1) % numStates]
            as Map);

    print("diffs curr:");
    print(diffsCurr);
    // print("testing");
    // print(diffsNext.values.every((err) => err < allowedErr));

    bool bestPose = true;
    // diffs_curr.forEach((k, v) {
    //   // Can't break foreach lol :)

    //   // if (!curr_err.containsKey(k)) {
    //   //   break;
    //   // }
    //   if (!curr_err.containsKey(k) && curr_err[k] < v) {
    //     best_pose = false;
    //     // break;
    //   }
    // });
    for (List<num> list in inferenceResults) {
      list.add(1.0);
    }

    for (final k in diffsCurr.keys) {
      if ((k as String).contains('both')) {
        List l = bothKeyPointDict[k]!;
        for (int idx in l) {
          double diff = diffsCurr[k] as double;
          double allignment = diff < allowedErr ? 1.0 : 0.0;
          inferenceResults[idx][3] = allignment;
        }
      }
    }

    for (final k in diffsCurr.keys) {
      if (!currErr.containsKey(k)) {
        break;
      }
      if (currErr[k] < diffsCurr[k]) {
        bestPose = false;
        break;
      }
    }

    if (bestPose) {
      currErr = diffsCurr;
    }

    if (diffsNext.values.every((err) => err < allowedErr)) {
      // currErr.forEach((k, v) {
      //   if (v > alert_err) {
      //     message.add(
      //         "Your form at your ${k.replaceAll('both_', '')} is a bit off");
      //   }
      // });

      currErr = {};
      state = (state + 1) % numStates;
      print("state: $state");
      if (state == 0) {
        _strenghtObject.repetitions += 1;
      }
    }
    print(inferenceResults);
    return inferenceResults;
  }
}
