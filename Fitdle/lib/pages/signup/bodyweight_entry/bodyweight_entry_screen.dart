import 'dart:async';
import 'package:fitdle/constants/all_constants.dart';
import 'package:fitdle/pages/signup/bodyweight_entry/bodyweight_entry_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/common.dart';

class BodyWeightScreen extends StatefulWidget {
  const BodyWeightScreen({Key? key}) : super(key: key);

  @override
  State<BodyWeightScreen> createState() => _BodyWeightScreenState();
}

class _BodyWeightScreenState extends State<BodyWeightScreen> {
  late final BodyWeightVM _bodyweightVM;
  late StreamSubscription _navigationSubscription;
  late StreamSubscription _errorSubscription;
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    _bodyweightVM = BodyWeightVM();
    _listen();
  }

  @override
  void dispose() {
    super.dispose();
    _bodyweightVM.dispose();
    _navigationSubscription.cancel();
    _errorSubscription.cancel();
  }

  _listen() {
    _navigationSubscription = _bodyweightVM.done.listen((value) {
      Navigator.pushNamed(context, "birthday");
    });

    _errorSubscription = _bodyweightVM.error.listen((msg) {
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
                  fitdleText(bodyweightEntry, h1, align: TextAlign.left),
                  SizedBox(height: size.height / 6),
                  fitdleIntField(bodyWeightController, weightUnit),
                  const SizedBox(height: regular),
                  primaryButton(ctn, continueButtonTapped)
                ])));
  }

  var bodyWeightController = TextEditingController();

  continueButtonTapped() {
    _bodyweightVM.updateBodyWeight(int.parse(bodyWeightController.text));
  }
}
