import 'dart:async';
import 'package:fitdle/constants/all_constants.dart';
import 'package:fitdle/pages/signup/personal_info/personal_info_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../components/common.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late final PersonalInfoVM _personalInfoVM;
  late StreamSubscription _navigationSubscription;

  @override
  void initState() {
    super.initState();
    _personalInfoVM = PersonalInfoVM();
    _listen();
  }

  @override
  void dispose() {
    super.dispose();
    _personalInfoVM.dispose();
    _navigationSubscription.cancel();
  }

  _listen() {
    _navigationSubscription = _personalInfoVM.done.listen((value) {
      Navigator.pushNamed(context, "birthday");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB (regular, size.height / 6, regular, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                fitdleText(hiThere, h1),
                fitdleText(namePrompt, h2),
                const SizedBox(height: large),
                fitdleTextField(firstNameController, firstName),
                const SizedBox(height: regular),
                fitdleTextField(lastNameController, lastName),
                const SizedBox(height: large),
                primaryButton(ctn, continueButtonTapped)
              ]
          ),
        )
    );
  }

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();

  continueButtonTapped() {
    _personalInfoVM.updatePersonalInfo(firstNameController.text, lastNameController.text);
  }


}
