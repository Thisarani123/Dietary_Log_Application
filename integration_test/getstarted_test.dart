import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/GetStarted.dart'; // Ensure this path is correct
import 'package:dietary_log_app/SigninPage.dart'; // Ensure this path is correct

void main() {
  patrolTest(
    'Getstarted navigates to Signinpage when "Get Started" is tapped',
    ($) async {
      // Initialize Patrol with NativeAutomatorConfig
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());

      // Start the app with Getstarted as the home widget
      await $.pumpWidget(const MaterialApp(home: Getstarted()));

      // Verify that the Splashpage is displayed
      expect($(find.byKey(const Key('splash_rich_text'))), findsOneWidget);

      // Verify the description text
      expect(
        $(find.text('Lose weight, get healthy, change your habits or start a new diet plan.')),
        findsOneWidget,
      );

      // Tap the "Get Started" button
      await $(find.text('Get Started')).tap();

      // Verify that the app navigates to the Signinpage
      expect($(find.text('Sign In')), findsOneWidget); // Replace 'Sign In' with the actual text on the Signinpage
    },
  );
}