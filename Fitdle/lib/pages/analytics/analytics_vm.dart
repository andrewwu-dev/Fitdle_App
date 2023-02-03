import 'package:fitdle/locator.dart';
import 'package:fitdle/models/earning.dart';
import 'package:fitdle/repository/api_response.dart';
import 'package:fitdle/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/chart_data.dart';

class AnalyticsVM extends ChangeNotifier {
  late final UserRepository _userRepo;
  late DateTime _startDate;
  late DateTime _endDate;
  late List<ChartData> _selectedData;
  var _options = [];
  var _shouldShowNextWeek = false;
  List<ChartData> _earningData = [
    // ChartData('MON', 12),
    // ChartData('TUE', 15),
    // ChartData('WED', 30),
    // ChartData('THU', 6),
    // ChartData('FRI', 14),
    // ChartData('SAT', 3),
    // ChartData('SUN', 17),
  ];
  List<ChartData> _calorieData = [
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
  String get startDate => "${_startDate.year}/${_startDate.month}/${_startDate.day}";
  String get endDate => "${_endDate.year}/${_endDate.month}/${_endDate.day}";
  bool get shouldShowNextWeek => _shouldShowNextWeek;

  AnalyticsVM([userRepo]) {
    _userRepo = userRepo ?? locator.get<UserRepository>();
    _selectedData = _earningData;
    _options = [_earningData, _calorieData];
    // Get the monday of the week
    // weekday is an index, monday is weekday=1 so 1-1 will give now.subtract(0).
    // which is still monday
    var now = DateTime.now();
    _startDate = now.subtract(Duration(days: now.weekday - 1));
    _endDate = _startDate.add(Duration(days: 6));
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

  Future<void> getEarningData() async {
    var res = await _userRepo.fetchEarnings(startDate, endDate);
    if(res is Success) {
      var earningsJson = res.data as List;
      List<Earning> earnings = earningsJson.map((json) => Earning.fromJson(json)).toList();
      for(Earning earning in earnings) {
        // TODO: sort earnings into _earningData
        // There can multiple earning per day so remember to accumulate
      }
    } else {
      res = res as Failure;
      _error.add(res.data);
    }
  }

  Future<void> getCalorieData() async {
    // TODO: Fetch calorie data
  }
}
