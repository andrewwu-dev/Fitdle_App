import 'package:fitdle/repository/auth_repository.dart';
import 'package:fitdle/repository/rewards_repository.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:fitdle/repository/exercise_repository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void diSetup() {
  locator.registerLazySingleton(() => AuthRepository());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => RewardsRepository());
  locator.registerLazySingleton(() => ExerciseRepository());
}
