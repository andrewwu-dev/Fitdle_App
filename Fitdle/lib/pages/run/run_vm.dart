import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:fitdle/repository/exercise_repository.dart';
import 'package:fitdle/models/exercise.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class RunVM extends ChangeNotifier {
  late final UserRepository _userRepo;
  late final ExerciseRepository _exerciseRepo;

  final PublishSubject<String> _error = PublishSubject();
  final PublishSubject _done = PublishSubject();

  PublishSubject<String> get error => _error;
  PublishSubject get done => _done;

  RunVM([authRepo, userRepo, exerciseRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
    _exerciseRepo = exerciseRepo ?? locator.get<ExerciseRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _error.close();
    _done.close();
  }

  Future<void> createRunLog(RunObject runObject) async {
    _exerciseRepo.logRun(_userRepo.user.id!, runObject);
  }
}
