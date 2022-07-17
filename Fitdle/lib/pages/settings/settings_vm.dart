import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class SettingsVM extends ChangeNotifier {
  late final AuthRepository _authRepo;

  final PublishSubject _loggedOut = PublishSubject();

  PublishSubject get loggedOut => _loggedOut;

  SettingsVM([authRepo]) {
    _authRepo = authRepo ?? locator.get<AuthRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _loggedOut.close();
  }

  logout() async {
    await _authRepo.logout();
    _loggedOut.sink.add(null);
  }
}
