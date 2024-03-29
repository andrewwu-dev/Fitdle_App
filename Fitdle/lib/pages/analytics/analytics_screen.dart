import 'package:fitdle/components/common.dart';
import 'package:fitdle/models/chart_data.dart';
import 'package:fitdle/pages/analytics/analytics_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late final AnalyticsVM _analyticsVM;
  late TooltipBehavior _tooltip;
  late Future<List<ChartData>> _chartData;

  int selectedGraph = 0;
  Color rewardsColor = Colors.white;
  Color caloriesColor = Colors.purple;

  @override
  void initState() {
    super.initState();
    _analyticsVM = AnalyticsVM();
    _tooltip = TooltipBehavior(enable: true);
    _chartData = _analyticsVM.getChartData();
  }

  @override
  void dispose() {
    super.dispose();
    _analyticsVM.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 100,
        titleSpacing: appBarPadding,
        backgroundColor: appBarColor,
        title: fitdleText(analytics, h2),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.purple,
        child: PageView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            body(size),
          ],
        ),
      ),
    );
  }

  _buildChart(data) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(labelRotation: -45),
      tooltipBehavior: _tooltip,
      series: <ChartSeries<ChartData, String>>[
        ColumnSeries<ChartData, String>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: (selectedGraph == 0) ? "Earnings" : "Calories",
            color: Colors.deepPurpleAccent),
      ],
    );
  }

  _moveDateBack() {
    setState(() {
      _analyticsVM.moveDateBack();
    });
    _refresh();
  }

  _moveDateForward() {
    setState(() {
      _analyticsVM.moveDateForward();
    });
    _refresh();
  }

  _switchGraphs(index) {
    setState(() {
      selectedGraph = index;
      _analyticsVM.switchGraph(index);
      rewardsColor = index == 0 ? Colors.white : Colors.purple;
      caloriesColor = index == 0 ? Colors.purple : Colors.white;
    });
    _refresh();
  }

  Future<void> _refresh() async {
    final res = await _analyticsVM.getChartData();
    setState(() {
      _chartData = Future.value(res);
    });
  }

  body(size) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(regular, regular, regular, 0),
      child: Column(children: [
        buildSegmentedControl(),
        const SizedBox(height: 20),
        buildWeekSwitch(),
        const SizedBox(height: large),
        FutureBuilder(
            future: _chartData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _buildChart(snapshot.data);
              } else {
                return const CircularProgressIndicator(color: Colors.purple);
              }
            }),
      ]),
    );
  }

  buildWeekSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            _moveDateBack();
          },
          icon: const Icon(Icons.chevron_left, color: Colors.purple),
        ),
        fitdleText("${_analyticsVM.startDate} - ${_analyticsVM.endDate}", hint),
        Visibility(
          visible: _analyticsVM.shouldShowNextWeek,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: IconButton(
              onPressed: () {
                _moveDateForward();
              },
              icon: const Icon(Icons.chevron_right, color: Colors.purple)),
        ),
      ],
    );
  }

  buildSegment(label, color) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: fitdleText(label, hint, color: color),
    );
  }

  buildSegmentedControl() {
    return CupertinoSegmentedControl(
      children: {
        0: buildSegment("Earnings", rewardsColor),
        1: buildSegment("Calories", caloriesColor),
      },
      onValueChanged: (int index) {
        _switchGraphs(index);
      },
      groupValue: selectedGraph,
      borderColor: Colors.purple,
      selectedColor: Colors.purple,
      pressedColor: Colors.purpleAccent.shade100,
    );
  }
}
