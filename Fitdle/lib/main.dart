import 'package:fitdle/locator.dart';
import 'package:fitdle/pages/login/login_screen.dart';
import 'package:fitdle/pages/signup/birthday_screen.dart';
import 'package:fitdle/pages/signup/create_account/create_account_screen.dart';
import 'package:fitdle/pages/signup/personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Used so that navigation doesn't require context to be passed in.
// TODO: Implement a better navigation pattern
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  di_setup();

  runApp(const Fitdle());
}

class Fitdle extends StatelessWidget {
  const Fitdle({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fitdle',
        initialRoute: 'login',
        navigatorKey: navigatorKey,
        routes: {
          'login': (context) => const LoginScreen(),
          'create_account': (context) => const CreateAccountScreen(),
          'personal_info': (context) => const PersonalInfoScreen(),
          'birthday': (context) => const BirthdayScreen()
        }
    );
  }
}