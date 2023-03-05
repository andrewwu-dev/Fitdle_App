import 'package:fitdle/constants/strings.dart';
import 'package:fitdle/locator.dart';
import 'package:fitdle/models/exercise.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:fitdle/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class Progress {
  int run, pushup, overheadPress, squat, bicepCurl;

  Progress(
      {required this.run,
      required this.pushup,
      required this.overheadPress,
      required this.squat,
      required this.bicepCurl});
}

Map<String, dynamic> movementGuidelines = {
  "18-64": {
    "run": {"goal": 20, "unit": minutes},
    "pushups": {"goal": 2, "unit": times},
    "overheadPress": {"goal": 2, "unit": times},
    "squats": {"goal": 2, "unit": times},
    "bicepCurls": {"goal": 2, "unit": times}
  },
  "65+": {
    "run": {"goal": 20, "unit": minutes},
    "pushups": {"goal": 2, "unit": times},
    "overheadPress": {"goal": 2, "unit": times},
    "squats": {"goal": 2, "unit": times},
    "bicepCurls": {"goal": 2, "unit": times}
  }
};

class HomeVM extends ChangeNotifier {
  late final UserRepository _userRepo;

  final PublishSubject<String> _subject = PublishSubject();
  final PublishSubject _done = PublishSubject();

  PublishSubject<String> get subject => _subject;
  PublishSubject get done => _done;

  HomeVM([userRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
    _done.close();
  }

  User getUser() {
    return _userRepo.user;
  }

  Future<Progress> getDailyProgress() async {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day);

    var res = await _userRepo.fetchExcercises(startTime.toIso8601String());

    Progress progress =
        Progress(run: 0, pushup: 0, overheadPress: 0, squat: 0, bicepCurl: 0);
    if (res is Success) {
      var data = res.data as Map<String, dynamic>;

      // parse run JSON objects
      var runsJson = data["run"] as List;
      List<Run> runs = runsJson.map((json) => Run.fromJson(json)).toList();

      // parse strength JSON objects
      var strengthJson = data["strength"] as List;
      // TODO: loop through each strength exercise, count frequency of each exercise
      List<Strength> strengthExercises =
          strengthJson.map((json) => Strength.fromJson(json)).toList();
      var exerciseHistory = ExerciseHistory(runs, strengthExercises);

      // print(data);
      for (Run run in exerciseHistory.runs) {
        Duration diff = run.endTimestamp.difference(run.startTimestamp);
        progress.run += diff.inMinutes;
      }
      for (Strength exercise in exerciseHistory.strengthExercises) {
        // -1 for api indexing, -1 again to ignore run
        final index = exercise.exerciseType - 2;
        switch (index) {
          case 0:
            progress.pushup += 1;
            break;
          case 1:
            progress.squat += 1;
            break;
          case 2:
            progress.overheadPress += 1;
            break;
          case 3:
            progress.bicepCurl += 1;
            break;
        }
      }
    }
    return progress;
  }

  int getTaskGoal(String category) {
    if (_userRepo.user.age != null) {
      int userAge = _userRepo.user.age!;
      if (userAge >= 18 && userAge <= 64) {
        return movementGuidelines["18-64"][category]["goal"];
      } else {
        return movementGuidelines["65+"][category]["goal"];
      }
    }
    return movementGuidelines["18-64"][category]["goal"];
  }
}
