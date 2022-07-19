import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/base_repository.dart';
import '../models/reward.dart';

abstract class RewardsRepositoryProtocol {
  Future<Object> getRewards();
}

class RewardsRepository extends BaseRepository implements RewardsRepositoryProtocol {
  @override
  Future<Object> getRewards() async {
    var res = await fetch("/rewards/");
    if(res is Success) {
      var rewardsJson = res.data as List;
      var rewards = rewardsJson.map((json) => Reward.fromJson(json)).toList();
      return Success(rewards);
    } else { // Failure
      return res;
    }
  }
}