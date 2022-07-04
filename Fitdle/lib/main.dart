import 'package:fitdle/scene/login/login_screen.dart';
import 'package:fitdle/scene/signup/birthday_screen.dart';
import 'package:fitdle/scene/signup/create_account_screen.dart';
import 'package:fitdle/scene/signup/personal_info_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Fitdle());
}

class Fitdle extends StatelessWidget {
  const Fitdle({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitdle',
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginScreen(),
        'create_account': (context) => const CreateAccountScreen(),
        'personal_info': (context) => const PersonalInfoScreen(),
        'birthday': (context) => const BirthdayScreen()
      },
    );
  }
}