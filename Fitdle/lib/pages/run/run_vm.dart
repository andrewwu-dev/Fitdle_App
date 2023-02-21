import 'package:fitdle/locator.dart';
import 'package:fitdle/models/earning.dart';
import 'package:fitdle/repository/rewards_repository.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:fitdle/repository/exercise_repository.dart';
import 'package:fitdle/models/exercise.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class RunVM extends ChangeNotifier {
  late final UserRepository _userRepo;
  late final ExerciseRepository _exerciseRepo;
  late final RewardsRepository _rewardsRepo;

  final PublishSubject<String> _error = PublishSubject();
  final PublishSubject _done = PublishSubject();

  PublishSubject<String> get error => _error;
  PublishSubject get done => _done;

  RunVM([userRepo, exerciseRepo, rewardsRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
    _exerciseRepo = exerciseRepo ?? locator.get<ExerciseRepository>();
    _rewardsRepo = rewardsRepo ?? locator.get<RewardsRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _error.close();
    _done.close();
  }

  Future<void> createRunLog(RunObject runObject) async {
    if (_userRepo.user.id == null) return;
    final id = _userRepo.user.id!;
    await _exerciseRepo.logRun(id, runObject);
    await _rewardsRepo.savePoints(id,
        Earning(id, DateTime.now().toIso8601String(), runObject.getPoints()));
  }
}
