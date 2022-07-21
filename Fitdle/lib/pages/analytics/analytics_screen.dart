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
  late StreamSubscription _navigationSubscription;
  late TooltipBehavior _tooltip;

  int selectedGraph = 0;
  Color rewardsColor = Colors.white;
  Color caloriesColor = Colors.purple;

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
    _navigationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        title: fitdleText(analytics, h2)
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.fromLTRB(regular, regular, regular, 0),
        child: Column(
          children: [
            buildSegmentedControl(),
            const SizedBox(height: 20),
            buildWeekSwitch(),
            const SizedBox(height: large),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              tooltipBehavior: _tooltip,
              series: <ChartSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                    dataSource: _analyticsVM.selectedData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    name: (selectedGraph == 0) ? "Earnings" : "Calories",
                    color: Colors.deepPurpleAccent)
              ])
          ]),
      ),
    );
  }

  buildWeekSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            onPressed:() {
              setState(() {_analyticsVM.moveDateBack();});
            },
            icon: const Icon(Icons.chevron_left, color: Colors.purple)
        ),
        fitdleText("${_analyticsVM.startDate} - ${_analyticsVM.endDate}", hint),
        IconButton(
            onPressed:() {
              setState(() {_analyticsVM.moveDateForward();});
            },
            icon: const Icon(Icons.chevron_right, color: Colors.purple)
        )
      ],
    );
  }

  buildSegment(label, color) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: fitdleText(label, hint, color: color)
    );
  }

  buildSegmentedControl() {
    return CupertinoSegmentedControl(
      children: {
        0: buildSegment("Earnings", rewardsColor),
        1: buildSegment("Calories", caloriesColor)
      },
      onValueChanged: (int index) {
        setState(() {
          selectedGraph = index;
          _analyticsVM.switchGraph(index);
          rewardsColor = index == 0 ? Colors.white : Colors.purple;
          caloriesColor = index == 0 ? Colors.purple : Colors.white;
        });
      },
      groupValue: selectedGraph,
      borderColor: Colors.purple,
      selectedColor: Colors.purple,
      pressedColor: Colors.purpleAccent.shade100,
    );
  }
}