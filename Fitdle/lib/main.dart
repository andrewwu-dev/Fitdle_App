import 'package:fitdle/scene/login/login_screen.dart';
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
      home: LoginScreen(),
    );
  }
}