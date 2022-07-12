import 'package:fitdle/constants/all_constants.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'redeem_screen.dart';
import 'settings_screen.dart';
import 'analytics_screen.dart';
import 'expandable_fab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  final screens = [
    const HomeScreen(),
    const AnalyticsScreen(),
    const RedeemScreen(),
    const SettingsScreen(),
  ];

  void navItemPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: analytics,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.redeem),
            label: redeem,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: settings,
          )
        ],
        currentIndex: selectedIndex,
        showUnselectedLabels: true,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: navItemPressed,
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.directions_run),
              label: run),
          ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.fitness_center),
              label: pushups),
          ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.videocam),
              label: squats),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
