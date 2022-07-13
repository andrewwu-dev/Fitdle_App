import 'package:fitdle/constants/all_constants.dart';
import 'home_vm.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        title: Text(
          "$hi ${_homeVM.getUser().firstName},",
          style: const TextStyle(
              fontFamily: 'Roboto', fontSize: h2, color: Colors.black),
        ),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(
            top: size.height / 12, left: regular, right: regular),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Text(dailyTasks,
                  style: TextStyle(fontFamily: 'Roboto', fontSize: h4)),
              SizedBox(height: 20),
              Text(weeklyTasks,
                  style: TextStyle(fontFamily: 'Roboto', fontSize: h4))
            ]),
      ),
    );
  }
}
