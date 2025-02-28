import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/GetStarted.dart'; 
import 'package:dietary_log_app/SigninPage.dart'; 
import 'package:firebase_core/firebase_core.dart'; 

void main() {
  patrolTest(
    'Getstarted navigates to Signinpage when "Get Started" is tapped',
    ($) async {
      // Initialize Firebase
      await Firebase.initializeApp();
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());

      await $.pumpWidget(const MaterialApp(home: Getstarted()));
      expect($(find.byKey(const Key('splash_rich_text'))), findsOneWidget);
      expect(
        $(find.text('Lose weight, get healthy, change your habits or start a new diet plan.')),findsOneWidget,);

      await $(find.text('Get Started')).tap();

      await $(find.text('SIGN IN')).waitUntilVisible();

      expect($(find.text('SIGN IN')), findsOneWidget);
    },
  );
}