import 'package:camera/camera.dart';
import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class CameraVM extends ChangeNotifier {
  late final AuthRepository _authRepo;

  final PublishSubject _loggedOut = PublishSubject();

  PublishSubject get loggedOut => _loggedOut;

  CameraVM([authRepo]) {
    _authRepo = authRepo ?? locator.get<AuthRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _loggedOut.close();
  }
}
