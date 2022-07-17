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

  getDailyProgress() {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day);
    var queryParam = {"start": startTime.toIso8601String()};
    var res = _userRepo.fetchDailyProgress(queryParam);

    Progress progress = Progress(lpa: 0, mvpa: 0, strength: 0);
    if (res is Success) {
      var data = (res as Success).data as Map<String, dynamic>;
      for (Run exercise in data["run"]) {
        if (exercise.numSteps != null) {
          progress.lpa += exercise.numSteps!;
        }
        Duration diff = exercise.endTimestamp.difference(exercise.startTimestamp);
        progress.mvpa += diff.inMinutes;
      }
      progress.strength += (data["strength"] as List<Strength>).length;
    }
    return progress;
  }
}
