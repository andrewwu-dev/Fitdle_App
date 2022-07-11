import 'package:fitdle/constants+utility.dart';
import 'package:fitdle/scene/dashboard/home_screen.dart';
import 'package:fitdle/scene/dashboard/analytics_screen.dart';
import 'package:fitdle/scene/dashboard/redeem_screen.dart';
import 'package:fitdle/scene/dashboard/settings_screen.dart';

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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.redeem),
            label: 'Redeem',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
        currentIndex: selectedIndex,
        showUnselectedLabels: true,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: navItemPressed,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
