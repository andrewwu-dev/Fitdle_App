import 'dart:async';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/pages/analytics/analytics_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitdle/constants/all_constants.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late final AnalyticsVM _analyticsVM;
  late StreamSubscription _navigationSubscription;
  int selectedGraph = 0;
  Color rewardsColor = Colors.white;
  Color caloriesColor = Colors.purple;

  @override
  void initState() {
    super.initState();
    _analyticsVM = AnalyticsVM();
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
            buildSegmentedControl()
          ]),
      ),
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
        0: buildSegment("Rewards", rewardsColor),
        1: buildSegment("Calories", caloriesColor)
      },
      onValueChanged: (int index) {
        setState(() {
          selectedGraph = index;
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
