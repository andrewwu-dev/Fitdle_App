import 'dart:async';
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

  int selectedGraph = 0;
  Color rewardsColor = Colors.white;
  Color caloriesColor = Colors.purple;
  late Future<List<ChartData>> _chartData;

  @override
  void initState() {
    super.initState();
    _analyticsVM = AnalyticsVM();
    _tooltip = TooltipBehavior(enable: true);
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        title: fitdleText(analytics, h2),
      ),
      body: body(size),
    );
  }

  _buildChart(data) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
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
    _analyticsVM.moveDateBack();
    setState(() {});
  }

  _moveDateForward() {
    _analyticsVM.moveDateForward();
    setState(() {});
  }

  _switchGraphs(index) {
    setState(() {
      selectedGraph = index;
      _analyticsVM.switchGraph(index);
      rewardsColor = index == 0 ? Colors.white : Colors.purple;
      caloriesColor = index == 0 ? Colors.purple : Colors.white;
    });
  }

  body(size) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(regular, regular, regular, 0),
      child: Column(children: [
        buildSegmentedControl(),
        const SizedBox(height: 20),
        buildWeekSwitch(),
        const SizedBox(height: large),
        FutureBuilder(
            future: _analyticsVM.getChartData(),
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
