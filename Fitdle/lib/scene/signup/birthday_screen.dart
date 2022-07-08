import 'package:fitdle/constants+utility.dart';
import 'package:flutter/cupertino.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}




class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({Key? key}) : super(key: key);

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  DateTime date = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.fromLTRB (regular, topPadding, regular, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              fitdleText(birthdayPrompt, h1),
              SizedBox(height: 110),
              TextButton(
                  onPressed: () => _selectDate(context),
                  child: fitdleText(
                    "${date.month}-${date.day}-${date.year}",
                    30.0,
                    Colors.purple
                  )
              ),
              SizedBox(height: 110),
              primaryButton(done, (){})
            ]
          )
        )
    );
  }
}
