import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/exercise_repository.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:fitdle/models/exercise.dart';

class CameraVM extends ChangeNotifier {
  late final ExerciseRepository _exerciseRepo;
  late final UserRepository _userRepo;
  final StrengthObject _strenghtObject = StrengthObject(DateTime.now());

  StrengthObject get strengthObject => _strenghtObject;

  CameraVM([userRepo, exerciseRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
    _exerciseRepo = exerciseRepo ?? locator.get<ExerciseRepository>();
  }

  updateRepetitions() {
    _strenghtObject.repetitions += 1;
  }

  getExcerciseType(excerciseName) {
    switch (excerciseName.toLowerCase()) {
      case "run":
        return 1;
    }
    // TODO: Make these enums and then the order them so run = index 0 and so forth.
  }

  Future<void> logStrength(excerciseName) async {
    if (_userRepo.user.id == null) return;
    _strenghtObject.endTimestamp = DateTime.now();
    // TODO: Update score and repetitions
    _exerciseRepo.logStrength(
      _userRepo.user.id!,
      _strenghtObject,
    );
  }
}
