import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../../../repository/api_response.dart';
import '../../repository/auth_repository.dart';

class LoginVM extends ChangeNotifier {
  late final AuthRepository _authRepo;
  late final UserRepository _userRepo;

  final PublishSubject<String> _subject = PublishSubject();
  final PublishSubject _done = PublishSubject();

  PublishSubject<String> get subject => _subject;
  PublishSubject get done => _done;


  LoginVM([authRepo, userRepo]) {
    _authRepo = authRepo ?? locator.get<AuthRepository>();
    _userRepo = userRepo ?? locator.get<UserRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
    _done.close();
  }

  login(email, password) async {
    var passwordHash = sha256.convert(utf8.encode(password)).toString();
    var res = await _authRepo.login(email, passwordHash);
    if(res is Failure) {
      _subject.sink.addError(res.data.toString());
      return;
    }
    var queryParam = {"email": email};
    res = _userRepo.fetchUser(queryParam);
    if(res is Failure) {
      _subject.sink.addError(res.data.toString());
    } else {
      _done.sink.add(null);
    }
  }
}