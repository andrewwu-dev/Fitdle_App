class Run {
  DateTime startTimestamp;
  DateTime endTimestamp;
  int exerciseType;
  int exerciseID;
  double avgPace;
  List<String>? path;
  int calories;
  int? numSteps;
  double distance;

  Run(
      {required this.startTimestamp,
      required this.endTimestamp,
      required this.exerciseType,
      required this.exerciseID,
      required this.avgPace,
      required this.calories,
      required this.distance});

  Map<String, dynamic> toJson() => {
        "startTimestamp": startTimestamp,
        "endTimestamp": endTimestamp,
        "exerciseType": exerciseType,
        "exerciseID": exerciseID,
        "avgPace": avgPace,
        "path": path,
        "calories": calories,
        "numSteps": numSteps,
        "distance": distance
      };

  update(
      {startTimestamp,
      endTimestamp,
      exerciseType,
      exerciseID,
      avgPace,
      path,
      calories,
      numSteps,
      distance}) {
    this.startTimestamp = startTimestamp;
    this.endTimestamp = endTimestamp;
    this.exerciseType = exerciseType;
    this.exerciseID = exerciseID;
    this.avgPace = avgPace;
    this.path ??= path;
    this.calories = calories;
    this.numSteps ??= numSteps;
    this.distance = distance;
  }
}

class Strength {
  DateTime startTimestamp;
  DateTime endTimestamp;
  int exerciseType;
  int exerciseID;
  int repetitions;
  double score;

  Strength(
      {
        required this.startTimestamp,
        required this.endTimestamp,
        required this.exerciseType,
        required this.exerciseID,
        required this.repetitions,
        required this.score
      }
  );

  Map<String, dynamic> toJson() => {
        "startTimestamp": startTimestamp,
        "endTimestamp": endTimestamp,
        "exerciseType": exerciseType,
        "exerciseID": exerciseID,
        "repetitions": repetitions,
        "score": score
      };

  update(
      {startTimestamp,
      endTimestamp,
      exerciseType,
      exerciseID,
      repetitions,
      score}) {
    this.startTimestamp = startTimestamp;
    this.endTimestamp = endTimestamp;
    this.exerciseType = exerciseType;
    this.exerciseID = exerciseID;
    this.repetitions = repetitions;
    this.score = score;
  }
}
