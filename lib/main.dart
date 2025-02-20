import 'package:dietary_log_app/HomePage.dart';
import 'package:dietary_log_app/SigninPage.dart';
import 'package:dietary_log_app/SignupPage.dart';
import 'package:dietary_log_app/SplashPage.dart';
import 'package:dietary_log_app/sidebar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',  // Start with splash screen
      routes: {
        '/splash': (context) => Splashpage(), // Splash screen
        '/login': (context) => Signinpage(), // Login screen
        '/signup': (context) => SignUpScreen(), // Signup screen
        '/home': (context) => sidebar(
              profileImageUrl: '',
              username: '',
              email: '',
            ), // Home (sidebar)
      },
    );
  }
}
