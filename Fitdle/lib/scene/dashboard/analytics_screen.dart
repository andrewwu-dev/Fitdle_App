import 'package:fitdle/constants+utility.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        title: const Text(
                analytics,
                style: TextStyle(fontFamily: 'Roboto', fontSize: h2, color: Colors.black),
            ),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(
            top: size.height / 12, left: regular, right: regular),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: const [
            
        ]),
      ),
    );
  }
}
