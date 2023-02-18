import 'package:fitdle/locator.dart';
import 'package:fitdle/models/earning.dart';
import 'package:fitdle/repository/exercise_repository.dart';
import 'package:fitdle/repository/rewards_repository.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:fitdle/models/exercise.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fitdle/repository/api_response.dart';

class CameraVM extends ChangeNotifier {
  late final ExerciseRepository _exerciseRepo;
  late final RewardsRepository _rewardsRepo;
  late final UserRepository _userRepo;
  final StrengthObject _strenghtObject = StrengthObject(DateTime.now());

  final PublishSubject<String> _error = PublishSubject();
  final PublishSubject _done = PublishSubject();

  PublishSubject<String> get error => _error;
  PublishSubject get done => _done;
  StrengthObject get strengthObject => _strenghtObject;

  CameraVM([userRepo, exerciseRepo, rewardsRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
    _rewardsRepo = rewardsRepo ?? locator.get<RewardsRepository>();
    _exerciseRepo = exerciseRepo ?? locator.get<ExerciseRepository>();
    // TODO: Only used to test right now, replace with actual pose estimation.
    _strenghtObject.repetitions = 5;
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

  num _calculateScore() {
    // TODO: Calculate score from pose estimation? 1 - 10 maybe?
    return 5;
  }

  Future<void> logStrength(ExerciseType type) async {
    if (_userRepo.user.id == null) return;
    _strenghtObject.endTimestamp = DateTime.now();
    // +1 because the enum starts at 0, but the API expects 1.
    _strenghtObject.exerciseType = type.index + 1;
    _strenghtObject.score = _calculateScore();
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
}
