import 'package:camera/camera.dart';
import 'package:fitdle/pages/camera/camera_screen.dart';
import 'package:fitdle/pages/login/login_screen.dart';
import 'package:fitdle/pages/run/run_screen.dart';
import 'package:fitdle/pages/signup/birthday/birthday_screen.dart';
import 'package:fitdle/pages/signup/create_account/create_account_screen.dart';
import 'package:fitdle/pages/signup/personal_info/personal_info_screen.dart';
import 'package:fitdle/pages/signup/bodyweight_entry/bodyweight_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'package:fitdle/models/exercise.dart';

// Used so that navigation doesn't require context to be passed in.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late List<CameraDescription>? _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  diSetup();
  try {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error retrieving cameras: $e');
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
          'run': (context) => const RunScreen(),
          'bodyWeight': (context) => const BodyWeightScreen(),
          'camera': (context) => CameraScreen(
                camera: _cameras!.firstWhere((camera) =>
                    camera.lensDirection == CameraLensDirection.front),
                exerciseType:
                    ModalRoute.of(context)?.settings.arguments as ExerciseType,
              )
        });
  }
}
