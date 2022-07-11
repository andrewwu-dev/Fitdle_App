import 'package:fitdle/scene/login/login_screen.dart';
import 'package:fitdle/scene/signup/birthday_screen.dart';
import 'package:fitdle/scene/signup/create_account_screen.dart';
import 'package:fitdle/scene/signup/personal_info_screen.dart';
import 'package:fitdle/scene/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        'birthday': (context) => const BirthdayScreen(),
        'dashboard': (context) => const DashboardScreen()
      },
    );
  }
}