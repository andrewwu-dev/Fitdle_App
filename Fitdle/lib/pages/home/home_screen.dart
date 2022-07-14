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
  final List<String> entries = <String>[dailyTasks, weeklyTasks];

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
        padding: const EdgeInsets.only(left: small, top: regular, right: small),
        child: 
            ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      entries[index],
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: h4)
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
        )
    );
  }

  String capitalize(String text) {
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }
}
