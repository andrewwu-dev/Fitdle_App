import 'package:fitdle/models/earning.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/base_repository.dart';
import '../models/reward.dart';

abstract class RewardsRepositoryProtocol {
  Future<Object> getRewards();
  Future<Object> redeemReward(int userID, int rewardID);
  Future<Object> savePoints(int userID, Earning earning);
}

class RewardsRepository extends BaseRepository
    implements RewardsRepositoryProtocol {
  @override
  Future<Object> getRewards() async {
    var res = await fetch("/rewards/");
    if (res is Success) {
      var rewardsJson = res.data as List;
      var rewards = rewardsJson.map((json) => Reward.fromJson(json)).toList();
      return Success(rewards);
    } else {
      // Failure
      return res;
    }
  }

  @override
  Future<Object> redeemReward(userID, rewardID) async {
    var res = await post("/rewards/redeem/$userID", {"rewardID": rewardID});
    return res;
  }

  @override
  Future<Object> savePoints(int userID, Earning earning) async {
    final res = await post("/rewards/earnings/$userID", earning.toJson());
    return res;
  }
}
