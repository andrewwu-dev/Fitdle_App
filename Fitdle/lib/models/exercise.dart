import 'dart:convert';

enum ExerciseType { run, pushups, squats }

final Map _caloriesPerRepetition = {
  ExerciseType.pushups: 0.5,
  ExerciseType.squats: 0.32,
};

class ExerciseHistory {
  List<Run> runs;
  List<Strength> strengthExercises;

  ExerciseHistory(this.runs, this.strengthExercises);

  Map<String, dynamic> toJson() => {
        "runs": runs,
        "strengthExercises": strengthExercises,
      };
}

class RunObject {
  int calories = 0;
  DateTime startTime;
  late DateTime endTime;
  double distance = 0;
  double avgPace = 0;
  List<Object> path = [];
  int exerciseType = 1;
  int numSteps = 0;

  RunObject(this.startTime);

  Map<String, dynamic> toJson() => {
        "startTimestamp": startTime.toIso8601String(),
        "endTimestamp": endTime.toIso8601String(),
        "exerciseType": exerciseType,
        "avgPace": avgPace,
        "path": jsonEncode(path),
        "calories": calories,
        "numSteps": numSteps,
        "distance": distance
      };
}

class Run {
  DateTime startTimestamp;
  DateTime endTimestamp;
  int exerciseType;
  int exerciseID;
  double avgPace;
  String? path;
  int calories;
  int? numSteps;
  double distance;

  Run(
      this.startTimestamp,
      this.endTimestamp,
      this.exerciseType,
      this.exerciseID,
      this.avgPace,
      this.path,
      this.calories,
      this.numSteps,
      this.distance);

  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      DateTime.parse(json['startTimestamp']),
      DateTime.parse(json['endTimestamp']),
      json['exerciseType'] as int,
      json['exerciseID'] as int,
      json['avgPace'] as double,
      json['path'] as String?,
      json['calories'] as int,
      json['numSteps'] as int,
      json['distance'] as double,
    );
  }

  Map<String, dynamic> toJson() => {
        "startTimestamp": startTimestamp.toIso8601String(),
        "endTimestamp": endTimestamp.toIso8601String(),
        "exerciseType": exerciseType,
        "exerciseID": exerciseID,
        "avgPace": avgPace,
        "path": path,
        "calories": calories,
        "numSteps": numSteps,
        "distance": distance
      };
}

class StrengthObject {
  DateTime startTimestamp;
  late DateTime endTimestamp;
  int exerciseType = 0;
  int repetitions = 0;
  double score = 0;

  StrengthObject(this.startTimestamp);

  Map<String, dynamic> toJson() => {
        "startTimestamp": startTimestamp.toIso8601String(),
        "endTimestamp": endTimestamp.toIso8601String(),
        "exerciseType": exerciseType,
        "repetitions": repetitions,
        "score": score
      };
}

class Strength {
  DateTime startTimestamp;
  DateTime endTimestamp;
  int exerciseType;
  int exerciseID;
  int repetitions;
  num score;

  Strength(this.startTimestamp, this.endTimestamp, this.exerciseType,
      this.exerciseID, this.repetitions, this.score);

  factory Strength.fromJson(Map<String, dynamic> json) {
    return Strength(
        DateTime.parse(json['startTimestamp']),
        DateTime.parse(json['endTimestamp']),
        json['exerciseType'] as int,
        json['exerciseID'] as int,
        json['repetitions'] as int,
        json['score'] as num);
  }

  Map<String, dynamic> toJson() => {
        "startTimestamp": startTimestamp.toIso8601String(),
        "endTimestamp": endTimestamp.toIso8601String(),
        "exerciseType": exerciseType,
        "exerciseID": exerciseID,
        "repetitions": repetitions,
        "score": score
      };

  int getCalories() {
    // -1 because the api starts at 1
    return (repetitions *
            _caloriesPerRepetition[ExerciseType.values[exerciseType - 1]])
        .floor();
  }
}
