import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fitdle/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../../../repository/api_response.dart';
import '../../repository/auth_repository.dart';

class LoginVM extends ChangeNotifier {
  late final AuthRepository _authRepo;

  final PublishSubject<String> _subject = PublishSubject();
  final PublishSubject _done = PublishSubject();

  PublishSubject<String> get subject => _subject;
  PublishSubject get done => _done;


  LoginVM([authRepo]) {
    _authRepo = authRepo ?? locator.get<AuthRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
  }

  login(email, password) async {
    var passwordHash = sha256.convert(utf8.encode(password)).toString();
    var res = await _authRepo.login(email, passwordHash);
    if(res is Failure) {
      _subject.sink.addError(res.data.toString());
    } else {
      _done.sink.add(null);
    }
  }
}