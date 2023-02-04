import 'package:fitdle/locator.dart';
import 'package:fitdle/models/earning.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/chart_data.dart';
import 'package:intl/intl.dart';

class AnalyticsVM extends ChangeNotifier {
  late final UserRepository _userRepo;
  late DateTime _startDate;
  late DateTime _endDate;
  late List<ChartData> _selectedData;
  var _options = [];
  var _shouldShowNextWeek = false;
  var _isLoading = true;
  final List<ChartData> _earningData = [];
  final List<ChartData> _calorieData = [
    ChartData('MON', 3),
    ChartData('TUE', 2),
    ChartData('WED', 5),
    ChartData('THU', 6),
    ChartData('FRI', 14),
    ChartData('SAT', 9),
    ChartData('SUN', 0),
  ];

  final PublishSubject _error = PublishSubject();

  PublishSubject get error => _error;
  List<ChartData> get selectedData => _selectedData;
  String get startDate =>
      "${_startDate.year}/${_startDate.month}/${_startDate.day}";
  String get endDate => "${_endDate.year}/${_endDate.month}/${_endDate.day}";
  bool get shouldShowNextWeek => _shouldShowNextWeek;
  bool get isLoading => _isLoading;

  AnalyticsVM([userRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
    _selectedData = _earningData;
    _options = [_earningData, _calorieData];
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
    _selectedData = _options[index];
  }

  moveDateBack() {
    var now = DateTime.now();
    _startDate = _startDate.subtract(const Duration(days: 7));
    _endDate = _endDate.subtract(const Duration(days: 7));
    _shouldShowNextWeek = !_endDate.isAfter(now);
    notifyListeners();
  }

  moveDateForward() {
    var now = DateTime.now();
    _startDate = _startDate.add(const Duration(days: 7));
    _endDate = _endDate.add(const Duration(days: 7));
    _shouldShowNextWeek = !_endDate.isAfter(now);
    notifyListeners();
  }

  Future<void> getChartData() async {
    if (_selectedData == _earningData) {
      await getEarningData();
    } else {
      await getCalorieData();
    }
  }

  Future<void> getEarningData() async {
    _isLoading = true;
    var res = await _userRepo.fetchEarnings(
        DateFormat('yyyy-MM-dd').format(_startDate),
        DateFormat('yyyy-MM-dd').format(_endDate.add(const Duration(days: 1))));
    if (res is Success) {
      var earningsJson = res.data as List;
      List<Earning> earnings =
          earningsJson.map((json) => Earning.fromJson(json)).toList();
      _earningData.clear();
      var earningMap = Map<String, int>();
      for (Earning earning in earnings) {
        // There can multiple earning per day so remember to accumulate
        final timestamp = DateFormat('yyyy-MM-dd').parse(earning.timestamp);
        final day = DateFormat('E').format(timestamp);
        earningMap[day] = (earningMap[day] ?? 0) + earning.points;
      }
      earningMap.forEach((key, value) {
        _earningData.add(ChartData(key, value));
      });
    } else {
      res = res as Failure;
      _error.add(res.data);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getCalorieData() async {
    _isLoading = true;
    // TODO: Fetch calorie data
    _isLoading = false;
    notifyListeners();
  }
}
