import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/auth_repository.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class BirthdayVM extends ChangeNotifier {
  late final UserRepository _userRepo;

  final PublishSubject<String> _subject = PublishSubject();
  final PublishSubject _done = PublishSubject();

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
  }

  saveUser(birthday) {
    _userRepo.user.update(birthDate: birthday);
    // TODO: Handle failure
    _userRepo.createUser();
    _done.sink.add(null);
  }
}