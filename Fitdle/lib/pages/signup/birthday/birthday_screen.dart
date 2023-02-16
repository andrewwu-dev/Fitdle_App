import 'dart:async';
import 'package:fitdle/constants/all_constants.dart';
import 'package:fitdle/pages/signup/birthday/brithday_vm.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/common.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({Key? key}) : super(key: key);

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  late final BirthdayVM _birthdayVM;
  late StreamSubscription _navigationSubscription;
  late StreamSubscription _errorSubscription;
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    _birthdayVM = BirthdayVM();
    _listen();
  }

  @override
  void dispose() {
    super.dispose();
    _birthdayVM.dispose();
    _navigationSubscription.cancel();
    _errorSubscription.cancel();
  }

  _listen() {
    _navigationSubscription = _birthdayVM.done.listen((value) {
      Navigator.pushNamedAndRemoveUntil(context, "dashboard", (_) => false);
    });

    _errorSubscription = _birthdayVM.error.listen((msg) {
      _isloading = false;
      setState(() {});
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (_isloading) return fitdleSpinner();

    return Scaffold(
        body: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(regular, size.height / 6, regular, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  fitdleText(birthdayPrompt, h1, align: TextAlign.left),
                  SizedBox(height: size.height / 6),
                  TextButton(
                      onPressed: () => _selectDate(context),
                      child: fitdleText(
                          "${date.month}-${date.day}-${date.year}", 30.0,
                          color: Colors.purple)),
                  SizedBox(height: size.height / 6),
                  primaryButton(done, doneButtonPressed)
                ])));
  }

  DateTime date = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1930, 1),
        lastDate: DateTime.now().add(const Duration(days: 1)));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  doneButtonPressed() {
    //YYYY-MM-DD
    String birthday = date.toString().substring(0, 10);
    _birthdayVM.saveUser(birthday);
  }
}
