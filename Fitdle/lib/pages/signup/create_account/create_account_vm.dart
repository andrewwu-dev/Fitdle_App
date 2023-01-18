import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fitdle/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../../../repository/api_response.dart';
import '../../../repository/auth_repository.dart';
import '../../../repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountVM extends ChangeNotifier {
  late final AuthRepository _authRepo;
  late final UserRepository _userRepo;

  final PublishSubject<String> _subject = PublishSubject();
  final PublishSubject _done = PublishSubject();

  PublishSubject<String> get subject => _subject;
  PublishSubject get done => _done;

  CreateAccountVM([authRepo, userRepo]) {
    _authRepo = authRepo ?? locator.get<AuthRepository>();
    _userRepo = userRepo ?? locator.get<UserRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
    _done.close();
  }

  Future<void> firebaseSignup(email, password) async {
    var passwordHash = sha256.convert(utf8.encode(password)).toString();
    // var res = await _authRepo.createAccount(email, passwordHash);
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    _userRepo.user.update(email: email);
    // if (res is Failure) {
    //   _subject.sink.addError(res.data.toString());
    // } else {
    //   _done.sink.add(null);
    // }
    _done.sink.add(null);
  }
}
