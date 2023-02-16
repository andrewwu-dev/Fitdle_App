import 'dart:async';
import 'package:fitdle/components/common.dart';
import 'package:fitdle/constants/all_constants.dart';
import 'package:fitdle/pages/settings/settings_vm.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsVM _settingsVM;
  late StreamSubscription _navigationSubscription;

  @override
  void initState() {
    super.initState();
    _settingsVM = SettingsVM();
    _listen();
  }

  @override
  void dispose() {
    super.dispose();
    _settingsVM.dispose();
    _navigationSubscription.cancel();
  }

  _listen() {
    // Pop to root (login page)
    _navigationSubscription = _settingsVM.loggedOut.listen((value) {
      Navigator.popAndPushNamed(context, "login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          title: fitdleText(settings, h2)),
      body: Container(
          alignment: Alignment.topLeft,
          color: const Color.fromARGB(255, 240, 240, 240),
          child: ListView(
            primary: false,
            children: [
              const SizedBox(height: regular),
              option(Icons.logout, "Log out", logoutPressed)
            ],
          )),
    );
  }

  logoutPressed() {
    _settingsVM.logout();
  }

  Container option(IconData icon, String label, action) {
    return Container(
        color: Colors.white,
        child: ListTile(
            leading: Icon(icon, color: Colors.purple),
            title: fitdleText(label, body, align: TextAlign.left),
            onTap: action,
            contentPadding: const EdgeInsets.fromLTRB(regular, 0, regular, 0)));
  }
}
