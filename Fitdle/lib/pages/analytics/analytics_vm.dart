import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class AnalyticsVM extends ChangeNotifier {
  late final AuthRepository _authRepo;

  final PublishSubject _subject = PublishSubject();

  PublishSubject get subject => _subject;

  AnalyticsVM([authRepo]) {
    _authRepo = authRepo ?? locator.get<AuthRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
  }
}
