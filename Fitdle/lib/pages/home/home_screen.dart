import 'home_vm.dart';
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

  @override
  void initState() {
    super.initState();
    _homeVM = HomeVM();
  }

  @override
  void dispose() {
    super.dispose();
    _homeVM.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _homeVM.getDailyProgress();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          title: Text(
            "$hi${_homeVM.getUser().firstName != null ? " ${capitalize(_homeVM.getUser().firstName!)}" : ""},",
            style: const TextStyle(
                fontFamily: 'Roboto', fontSize: h2, color: Colors.black),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: small, right: small),
          child: ListView(
            padding: const EdgeInsets.all(8),
            primary: false,
            children: const [
              SizedBox(height: regular),
              Text(dailyTasks,
                  style: TextStyle(fontFamily: 'Roboto', fontSize: h4)),
              SizedBox(height: 20),
              Task(
                  category: lpa,
                  icon: Icon(Icons.directions_walk, size: h3),
                  unit: steps,
                  taskProgress: 0,
                  goal: 7000),
              SizedBox(height: 20),
              Task(
                  category: mvpa,
                  icon: Icon(Icons.directions_run, size: h3),
                  unit: minutes,
                  taskProgress: 5,
                  goal: 20),
              SizedBox(height: 20),
              Text(weeklyTasks,
                  style: TextStyle(fontFamily: 'Roboto', fontSize: h4)),
              SizedBox(height: 20),
              Task(
                  category: strength,
                  icon: Icon(Icons.fitness_center, size: h3),
                  unit: times,
                  taskProgress: 0,
                  goal: 2),
              SizedBox(height: 20),
            ],
          ),
        ));
  }

  String capitalize(String text) {
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }
}
