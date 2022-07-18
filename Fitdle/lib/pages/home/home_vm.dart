import 'package:fitdle/constants/strings.dart';
import 'package:fitdle/locator.dart';
import 'package:fitdle/models/exercise.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:fitdle/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class Progress {
  int lpa;
  int mvpa;
  int strength;

  Progress({required this.lpa, required this.mvpa, required this.strength});
}

Map<String, dynamic> movementGuidelines = {
  "18-64": {
    "lpa": {"goal": 7500, "unit": steps},
    "mvpa": {"goal": 150, "unit": minutes},
    "strength": {"goal": 2, "unit": times}
  },
  "65+": {
    "lpa": {"goal": 5500, "unit": steps},
    "mvpa": {"goal": 150, "unit": minutes},
    "strength": {"goal": 2, "unit": times}
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
    var queryParam = {"start": startTime.toIso8601String()};

    var res = await _userRepo.fetchDailyProgress(queryParam);

    Progress progress = Progress(lpa: 0, mvpa: 0, strength: 0);
    if (res is Success) {
      var data = res.data as Map<String, dynamic>;

      // parse run JSON objects
      var runsJson = data["run"] as List;
      List<Run> runs = runsJson.map((json) => Run.fromJson(json)).toList();

      // parse strength JSON objects
      var strengthJson = data["strength"] as List;
      List<Strength> strengthExercises = strengthJson.map((json) => Strength.fromJson(json)).toList();

      var exerciseHistory = ExerciseHistory(runs, strengthExercises);

      // print(data);
      for (Run run in exerciseHistory.runs) {
        if (run.numSteps != null) {
          progress.lpa += run.numSteps!;
        }
        Duration diff = run.endTimestamp.difference(run.startTimestamp);
        progress.mvpa += diff.inMinutes;
      }
      progress.strength += exerciseHistory.strengthExercises.length;
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
