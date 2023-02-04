import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/auth_repository.dart';
import 'package:fitdle/repository/exercise_repository.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class CameraVM extends ChangeNotifier {
  late final ExerciseRepository _exerciseRepo;
  late final UserRepository _userRepo;

  CameraVM([userRepo, exerciseRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
    _exerciseRepo = exerciseRepo ?? locator.get<ExerciseRepository>();
  }

  Future<void> logStrength() async {
    if (_userRepo.user.id == Null) return;
    _exerciseRepo.logStrength(
      _userRepo.user.id,
      strengthObject,
    );
  }
}
