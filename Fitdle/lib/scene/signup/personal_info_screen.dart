import 'package:fitdle/constants+utility.dart';
import 'package:flutter/cupertino.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  continueButtonTapped() {
    Navigator.pushNamed(context, "birthday");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.fromLTRB (regular, topPadding, regular, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              fitdleText(hiThere, h1),
              fitdleText(namePrompt, h2),
              SizedBox(height: large),
              fitdleTextField(firstName),
              SizedBox(height: regular),
              fitdleTextField(lastName),
              SizedBox(height: large),
              primaryButton(ctn, continueButtonTapped)
            ]
          ),
        )
    );
  }
}
