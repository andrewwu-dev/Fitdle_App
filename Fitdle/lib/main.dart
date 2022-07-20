import 'package:fitdle/pages/dashboard/dashboard_screen.dart';
import 'package:fitdle/pages/login/login_screen.dart';
import 'package:fitdle/pages/run/run_screen.dart';
import 'package:fitdle/pages/signup/birthday/birthday_screen.dart';
import 'package:fitdle/pages/signup/create_account/create_account_screen.dart';
import 'package:fitdle/pages/signup/personal_info/personal_info_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'firebase_options.dart';
import 'locator.dart';

// Used so that navigation doesn't require context to be passed in.
// TODO: Implement a better navigation pattern
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  di_setup();

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

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
          'birthday': (context) => const BirthdayScreen(),
          'dashboard': (context) => const DashboardScreen(),
          'run': (context) => const RunScreen()
        });
  }
}
