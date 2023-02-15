import 'package:fitdle/repository/base_repository.dart';
import 'package:fitdle/models/exercise.dart';

abstract class ExerciseRepositoryProtocol {
  Future<Object> logRun(int userID, RunObject runObject);
  Future<Object> logStrength(int userID, StrengthObject strengthObject);
  int getExerciseTypeIndex(ExerciseType type);
}

class ExerciseRepository extends BaseRepository
    implements ExerciseRepositoryProtocol {
  @override
  Future<Object> logRun(userID, runObject) async {
    var res = await post("/users/exercises/$userID", runObject.toJson());
    return res;
  }

  @override
  Future<Object> logStrength(userID, strengthObject) async {
    var res = await post("/users/exercises/$userID", strengthObject.toJson());
    return res;
  }

  @override
  int getExerciseTypeIndex(ExerciseType type) {
    switch (type) {
      case ExerciseType.run:
        return 0;
      case ExerciseType.pushups:
        return 1;
      case ExerciseType.squats:
        return 2;
    }
  }
}
