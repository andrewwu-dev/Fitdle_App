import 'package:fitdle/locator.dart';
import 'package:fitdle/models/earning.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/chart_data.dart';
import 'package:intl/intl.dart';
import 'package:fitdle/models/exercise.dart';

enum GraphType {
  earnings,
  calories,
}

class AnalyticsVM extends ChangeNotifier {
  late final UserRepository _userRepo;
  late DateTime _startDate;
  late DateTime _endDate;
  var _selectedGraph = GraphType.earnings;
  var _shouldShowNextWeek = false;

  final PublishSubject _error = PublishSubject();

  PublishSubject get error => _error;
  String get startDate =>
      "${_startDate.year}/${_startDate.month}/${_startDate.day}";
  String get endDate => "${_endDate.year}/${_endDate.month}/${_endDate.day}";
  bool get shouldShowNextWeek => _shouldShowNextWeek;

  AnalyticsVM([userRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
    // Get the monday of the week
    // weekday is an index, monday is weekday=1 so 1-1 will give now.subtract(0).
    // which is still monday
    var now = DateTime.now();
    _startDate = now.subtract(Duration(days: now.weekday - 1));
    _endDate = _startDate.add(const Duration(days: 6));
  }

  @override
  void dispose() {
    super.dispose();
    _error.close();
  }

  switchGraph(int index) {
    // _selectedData = _options[index];
    _selectedGraph = GraphType.values[index];
  }

  moveDateBack() {
    var now = DateTime.now();
    _startDate = _startDate.subtract(const Duration(days: 7));
    _endDate = _endDate.subtract(const Duration(days: 7));
    _shouldShowNextWeek = !_endDate.isAfter(now);
  }

  moveDateForward() {
    var now = DateTime.now();
    _startDate = _startDate.add(const Duration(days: 7));
    _endDate = _endDate.add(const Duration(days: 7));
    _shouldShowNextWeek = !_endDate.isAfter(now);
  }

  Future<List<ChartData>> getChartData() async {
    return (_selectedGraph == GraphType.earnings)
        ? await _getEarningData()
        : await _getCalorieData();
  }

  Future<List<ChartData>> _getEarningData() async {
    var earningData = <ChartData>[];
    var res = await _userRepo.fetchEarnings(
        DateFormat('yyyy-MM-dd').format(_startDate),
        // Add one day to the end date to include the last day
        DateFormat('yyyy-MM-dd').format(_endDate.add(const Duration(days: 1))));
    if (res is Success) {
      var earningsJson = res.data as List;
      List<Earning> earnings =
          earningsJson.map((json) => Earning.fromJson(json)).toList();
      var earningMap = <String, int>{};
      for (int i = 0; i < 7; i++) {
        final day =
            DateFormat('E MM/dd').format(_startDate.add(Duration(days: i)));
        earningMap[day] = 0;
      }
      for (Earning earning in earnings) {
        // There can multiple earning per day so remember to accumulate
        final timestamp = DateFormat('yyyy-MM-dd').parse(earning.timestamp);
        final day = DateFormat('E MM/dd').format(timestamp);
        earningMap[day] = (earningMap[day] ?? 0) + earning.points;
      }
      earningMap.forEach((key, value) {
        earningData.add(ChartData(key, value));
      });
    } else {
      res = res as Failure;
      _error.add(res.data);
    }
    return earningData;
  }

  Future<List<ChartData>> _getCalorieData() async {
    var calorieData = <ChartData>[];
    var res = await _userRepo.fetchExcercises(
        DateFormat('yyyy-MM-dd').format(_startDate),
        // Add one day to the end date to include the last day
        DateFormat('yyyy-MM-dd').format(_endDate.add(const Duration(days: 1))));
    if (res is Success) {
      var json = res.data as Map;
      var runJson = json['run'] as List;
      var strengthJson = json['strength'] as List;
      List<Strength> strengthDataList =
          strengthJson.map((json) => Strength.fromJson(json)).toList();
      List<Run> runDataList =
          runJson.map((json) => Run.fromJson(json)).toList();

      var calorieMap = <String, int>{};
      for (int i = 0; i < 7; i++) {
        final day =
            DateFormat('E MM/dd').format(_startDate.add(Duration(days: i)));
        calorieMap[day] = 0;
      }
      for (Strength strengthData in strengthDataList) {
        final day = DateFormat('E MM/dd').format(strengthData.endTimestamp);
        calorieMap[day] = (calorieMap[day] ?? 0) + strengthData.getCalories();
      }
      for (Run runData in runDataList) {
        final day = DateFormat('E MM/dd').format(runData.endTimestamp);
        calorieMap[day] = (calorieMap[day] ?? 0) + runData.calories;
      }
      calorieMap.forEach((key, value) {
        calorieData.add(ChartData(key, value));
      });
    } else {
      res = res as Failure;
      _error.add(res.data);
    }
    return calorieData;
  }
}
