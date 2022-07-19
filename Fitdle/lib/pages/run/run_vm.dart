import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class RunObject {
  int calories = 0;
  DateTime startTime;
  late DateTime endTime;
  double distance = 0;
  List<LatLng> path = [];
  int exerciseType = 1;

  RunObject(this.startTime);
}

class RunVM extends ChangeNotifier {
  late final UserRepository _userRepo;

  final PublishSubject<String> _error = PublishSubject();
  final PublishSubject _done = PublishSubject();

  PublishSubject<String> get error => _error;
  PublishSubject get done => _done;

  RunVM([authRepo, userRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _error.close();
    _done.close();
  }

  Future<void> createRunLog(RunObject runObject) async {

  }
}
