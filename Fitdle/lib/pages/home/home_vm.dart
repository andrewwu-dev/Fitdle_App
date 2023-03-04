import 'package:fitdle/constants/strings.dart';
import 'package:fitdle/locator.dart';
import 'package:fitdle/models/exercise.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:fitdle/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class Progress {
  int run, pushups, overheadPress, squats, bicepCurls;

  Progress(
      {required this.run,
      required this.pushups,
      required this.overheadPress,
      required this.squats,
      required this.bicepCurls});
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

    Progress progress = Progress(
        run: 0, pushups: 0, overheadPress: 0, squats: 0, bicepCurls: 0);
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
            progress.pushups += exercise.repetitions;
            break;
          case 1:
            progress.squats += exercise.repetitions;
            break;
          case 2:
            progress.overheadPress += exercise.repetitions;
            break;
          case 3:
            progress.bicepCurls += exercise.repetitions;
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
