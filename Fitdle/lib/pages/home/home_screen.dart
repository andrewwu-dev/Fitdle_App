import 'home_vm.dart';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:flutter/material.dart';
import 'task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeVM _homeVM;
  late Future<Progress> _progress;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _homeVM = HomeVM();
    _progress = _homeVM.getDailyProgress();
  }

  @override
  void dispose() {
    _homeVM.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final res = await _homeVM.getDailyProgress();
    setState(() {
      _progress = Future.value(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _progress,
        builder: (BuildContext context, AsyncSnapshot<Progress> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Progress progress = snapshot.data!;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: backgroundColor,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: false,
                elevation: 0,
                backgroundColor: appBarColor,
                toolbarHeight: 100,
                titleSpacing: appBarPadding,
                title: fitdleText(
                    "$hi${_homeVM.getUser().firstName != null ? " ${capitalize(_homeVM.getUser().firstName!)}" : ""},",
                    h2),
              ),
              body: RefreshIndicator(
                onRefresh: _refresh,
                backgroundColor: backgroundColor,
                color: Colors.purple,
                child: body(context, progress),
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(color: Colors.purple));
          }
        });
  }

  Widget body(BuildContext context, Progress progress) {
    return ListView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        padding: const EdgeInsets.all(small + 8),
        primary: false,
        children: [
          Image.asset(dashboardSplash, height: 300),
          const SizedBox(height: regular),
          fitdleText(dailyTasks, h4, align: TextAlign.left),
          const SizedBox(height: 20),
          Task(
            category: run,
            unit: minutes,
            taskProgress: progress.run,
            goal: _homeVM.getTaskGoal("run"),
            color: runCardColor,
          ),
          const SizedBox(height: 20),
          Task(
              category: pushup,
              unit: times,
              taskProgress: progress.pushup,
              goal: _homeVM.getTaskGoal("pushup"),
              color: pushupsCardColor),
          const SizedBox(height: 20),
          Task(
              category: overheadPress,
              unit: times,
              taskProgress: progress.overheadPress,
              goal: _homeVM.getTaskGoal("overheadPress"),
              color: overheadPressCardColor),
          const SizedBox(height: 20),
          Task(
              category: squat,
              unit: times,
              taskProgress: progress.squat,
              goal: _homeVM.getTaskGoal("squat"),
              color: squatsCardColor),
          const SizedBox(height: 20),
          Task(
              category: bicepCurl,
              unit: times,
              taskProgress: progress.bicepCurl,
              goal: _homeVM.getTaskGoal("bicepCurl"),
              color: bicpCurlCardColor),
          const SizedBox(height: 20),
        ]);
  }

  String capitalize(String text) {
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }
}
