import 'package:fitdle/repository/base_repository.dart';
import 'package:fitdle/models/exercise.dart';

abstract class ExerciseRepositoryProtocol {
  Future<Object> logRun(int userID, RunObject runObject);
}

class ExerciseRepository extends BaseRepository
    implements ExerciseRepositoryProtocol {
  @override
  Future<Object> logRun(userID, runObject) async {
    var res = await post("/users/exercises/$userID", runObject.toJson());
    return res;
  }
}
