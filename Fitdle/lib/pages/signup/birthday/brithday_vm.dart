import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/auth_repository.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class BirthdayVM extends ChangeNotifier {
  late final UserRepository _userRepo;

  final PublishSubject<String> _error = PublishSubject();
  final PublishSubject<String> _subject = PublishSubject();
  final PublishSubject _done = PublishSubject();

  PublishSubject<String> get error => _error;
  PublishSubject<String> get subject => _subject;
  PublishSubject get done => _done;


  BirthdayVM([userRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
    _done.close();
    _error.close();
  }

  Future<void> saveUser(birthday) async {
    _userRepo.user.update(birthDate: birthday);
    var res = await _userRepo.createUser();

    if (res is Failure) {
      _error.sink.add(res.data.toString());
      return;
    }
    res = await _userRepo.fetchUser(_userRepo.user.email);
    if (res is Failure) {
      _error.sink.add("Unable to retrieve user data");
    } else {
      _done.sink.add(null);
    }
  }
}