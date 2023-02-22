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
                child: PageView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    body(context, progress),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(color: Colors.purple));
          }
        });
  }

  Widget body(BuildContext context, Progress progress) {
    return Container(
      padding: const EdgeInsets.only(left: small, right: small),
      color: backgroundColor,
      height: MediaQuery.of(context).size.height,
      child:
          ListView(padding: const EdgeInsets.all(8), primary: false, children: [
        const SizedBox(height: regular),
        fitdleText(dailyTasks, h4, align: TextAlign.left),
        const SizedBox(height: 20),
        Task(
            category: lpa,
            icon: const Icon(Icons.directions_walk, size: h3),
            unit: steps,
            taskProgress: progress.lpa,
            goal: _homeVM.getTaskGoal("lpa")),
        const SizedBox(height: 20),
        fitdleText(weeklyTasks, h4, align: TextAlign.left),
        const SizedBox(height: 20),
        Task(
            category: mvpa,
            icon: const Icon(Icons.directions_run, size: h3),
            unit: minutes,
            taskProgress: progress.mvpa,
            goal: _homeVM.getTaskGoal("mvpa")),
        const SizedBox(height: 20),
        Task(
            category: strength,
            icon: const Icon(Icons.fitness_center, size: h3),
            unit: times,
            taskProgress: progress.strength,
            goal: _homeVM.getTaskGoal("strength")),
        const SizedBox(height: 20)
      ]),
    );
  }

  String capitalize(String text) {
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }
}
