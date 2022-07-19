import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/rewards_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/reward.dart';

class RedeemVM extends ChangeNotifier {
  late final RewardsRepository _rewardsRepo;

  final PublishSubject _subject = PublishSubject();
  final PublishSubject<String> _error = PublishSubject();

  PublishSubject get subject => _subject;
  PublishSubject<String> get error => _error;

  List<Reward> rewards = [];

  RedeemVM([rewardsRepo]) {
    _rewardsRepo = rewardsRepo ?? locator.get<RewardsRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
    _error.close();
  }

  Future<void> getRewards() async {
    var res = await _rewardsRepo.getRewards();
    if (res is Success) {
      rewards = res.data as List<Reward>;
      print("");
    } else {
      res = res as Failure;
      print(res.data.toString());
      _error.add(res.data.toString());
    }
  }
}
