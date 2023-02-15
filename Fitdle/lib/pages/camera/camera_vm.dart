import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/exercise_repository.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:fitdle/models/exercise.dart';
import 'package:rxdart/rxdart.dart';
import '../../repository/api_response.dart';

class CameraVM extends ChangeNotifier {
  late final ExerciseRepository _exerciseRepo;
  late final UserRepository _userRepo;
  final StrengthObject _strenghtObject = StrengthObject(DateTime.now());

  final PublishSubject<String> _error = PublishSubject();
  final PublishSubject _done = PublishSubject();

  PublishSubject<String> get error => _error;
  PublishSubject get done => _done;
  StrengthObject get strengthObject => _strenghtObject;

  CameraVM([userRepo, exerciseRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
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

  _calculateScore() {
    // TODO: Figure out how to calculate score based on exercise?
    const pointsPerRep = 10.0;
    _strenghtObject.score = pointsPerRep * _strenghtObject.repetitions;
  }

  Future<void> logStrength(ExerciseType type) async {
    if (_userRepo.user.id == null) return;
    _strenghtObject.endTimestamp = DateTime.now();
    _strenghtObject.exerciseType = _exerciseRepo.getExerciseTypeIndex(type);
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
}
