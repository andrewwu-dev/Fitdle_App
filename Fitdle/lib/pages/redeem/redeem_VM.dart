import 'package:fitdle/locator.dart';
import 'package:fitdle/repository/rewards_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/reward.dart';

class RedeemVM extends ChangeNotifier {
  late final RewardsRepository _rewardsRepo;
  List<Reward> rewards = [
    Reward(null, "E-Book: Healthy Living", "a book about living healthy.", 1000, true),
    Reward(null, "E-Book: Healthy Living", "a book about living healthy.", 1000, true),
    Reward(null, "E-Book: Healthy Living", "a book about living healthy.", 1000, true),
    Reward(null, "E-Book: Healthy Living", "a book about living healthy.", 1000, true),
    Reward(null, "E-Book: Healthy Living", "a book about living healthy.", 1000, true),
    Reward(null, "E-Book: Healthy Living", "a book about living healthy.", 1000, true),

  ];

  final PublishSubject _subject = PublishSubject();

  PublishSubject get subject => _subject;

  RedeemVM([rewardsRepo]) {
    _rewardsRepo = rewardsRepo ?? locator.get<RewardsRepository>();
  }

  @override
  void dispose() {
    super.dispose();
    _subject.close();
  }
}
