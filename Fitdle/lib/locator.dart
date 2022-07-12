import 'package:fitdle/repository/auth_repository.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void di_setup() {
  locator.registerLazySingleton(() => AuthRepository());
  locator.registerLazySingleton(() => UserRepository());
}
