import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/auth_repository.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class SettingsVM extends ChangeNotifier {
  late final AuthRepository _authRepo;
  late final UserRepository _userRepo;

  final PublishSubject _loggedOut = PublishSubject();

  PublishSubject get loggedOut => _loggedOut;

  SettingsVM([authRepo, userRepo]) {
    _authRepo = authRepo ?? locator.get<AuthRepository>();
    _userRepo = userRepo ?? locator.get<UserRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _loggedOut.close();
  }

  logout() async {
    await _authRepo.logout();
    _userRepo.clearUser();
    _loggedOut.sink.add(null);
  }
}
