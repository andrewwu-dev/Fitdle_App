import 'package:fitdle/constants+utility.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        title: const Text(
                "$hi Bill,",
                style: TextStyle(fontFamily: 'Roboto', fontSize: h2, color: Colors.black),
            ),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(
            top: size.height / 12, left: regular, right: regular),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: const [
            Text(
                dailyTasks,
                style: TextStyle(fontFamily: 'Roboto', fontSize: h4)
            ),
            SizedBox(height: 20),
            Text(
                weeklyTasks,
                style: TextStyle(fontFamily: 'Roboto', fontSize: h4)
            )
        ]),
      ),
    );
  }
}
