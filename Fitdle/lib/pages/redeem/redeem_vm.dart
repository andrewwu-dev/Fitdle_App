import 'package:fitdle/locator.dart';
import 'package:fitdle/models/user.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/rewards_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/reward.dart';
import '../../repository/user_repository.dart';

class RedeemVM extends ChangeNotifier {
  late final RewardsRepository _rewardsRepo;
  late final UserRepository _userRepo;

  final PublishSubject _subject = PublishSubject();
  final PublishSubject<String> _error = PublishSubject();

  PublishSubject get subject => _subject;
  PublishSubject<String> get error => _error;
  User get user => _userRepo.user;

  List<Reward> rewards = [];

  RedeemVM([rewardsRepo, userRepo]) {
    _rewardsRepo = rewardsRepo ?? locator.get<RewardsRepository>();
    _userRepo = userRepo ?? locator.get<UserRepository>();
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
    } else {
      res = res as Failure;
      _error.add(res.data.toString());
    }
  }

  Future<String?> redeemReward(index, rewardID) async {
    if ((_userRepo.user.numPoints ?? 0) < rewards[index].cost) {
      _error.add("You don't have enough points to redeem this reward");
      return null;
    }
    var res = await _rewardsRepo.redeemReward(user.id!, rewardID);
    if (res is Success) {
      var result = res.data as Map<String, dynamic>;
      _userRepo.updateUser(result["user"]);
      return result["code"];
    } else {
      res = res as Failure;
      _error.add(res.data.toString());
      return null;
    }
  }
}
