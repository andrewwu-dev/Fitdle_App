import 'package:camera/camera.dart';
import 'package:fitdle/locator.dart';
import 'package:fitdle/pages/camera/pose_estimation.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/exercise_repository.dart';
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

  CameraVM([userRepo, exerciseRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
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
    final res = await _exerciseRepo.logStrength(
      _userRepo.user.id!,
      _strenghtObject,
    );
    if (res is Failure) {
      _error.sink.add("Unable to save exercise data");
    } else {
      _done.sink.add(null);
    }
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
    print("inference results");
    print(inferenceResults);

    final exercise = exerciseType.name;
    int numStates = (EXERCISES[exercise]!['states'] as List).length;
    int allowed_err = EXERCISES[exercise]!['allowed_err'] as int;
    int alert_err = EXERCISES[exercise]!['alert_err'] as int;

    var diffs_curr = poseEstimation.verifyOutput(
        inferences, (EXERCISES[exercise]!['states'] as List)[state] as Map);
    var diffs_next = poseEstimation.verifyOutput(
        inferences,
        (EXERCISES[exercise]!['states'] as List)[(state + 1) % numStates]
            as Map);

    print("diffs curr:");
    print(diffs_curr);
    print("testing");
    print(diffs_next.values.every((err) => err < allowed_err));

    bool best_pose = true;
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
    for (final k in diffs_curr.keys) {
      if (!currErr.containsKey(k)) {
        break;
      }
      if (currErr[k] < diffs_curr[k]) {
        best_pose = false;
        break;
      }
    }

    if (best_pose) {
      currErr = diffs_curr;
    }

    if (diffs_next.values.every((err) => err < allowed_err)) {
      // currErr.forEach((k, v) {
      //   if (v > alert_err) {
      //     message.add(
      //         "Your form at your ${k.replaceAll('both_', '')} is a bit off");
      //   }
      // });

      currErr = {};
      state = (state + 1) % numStates;
      print("INCREASE STATE");
      if (state == 0) {
        _strenghtObject.repetitions += 1;
      }
    }
    return inferenceResults;
  }
}
