import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/Getstarted.dart'; // Import Getstarted page
import 'package:dietary_log_app/SigninPage.dart'; // Import Signinpage

void main() {
  patrolTest(
    'Getstarted Page Test',
    ($) async {
      // Step 1: Initialize Firebase
      try {
        await Firebase.initializeApp();
        print("Firebase initialized successfully");
      } catch (e) {
        print("Firebase initialization failed: $e");
      }

      // Step 2: Initialize Patrol with NativeAutomatorConfig
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());

      // Step 3: Start the app with Getstarted as the home widget
      await $.pumpWidget(MaterialApp(
        home: Getstarted(),
      ));

      // Step 4: Add a delay for asset loading
      await Future.delayed(Duration(seconds: 2));

      // Step 5: Verify the presence of the "HealthBites" logo text
      await $(find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final richText = widget;
          return richText.text.toPlainText().contains('Health');
        }
        return false;
      })).waitUntilVisible();

      expect($(find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final richText = widget;
          return richText.text.toPlainText().contains('Health');
        }
        return false;
      })), findsOneWidget);

      expect($(find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final richText = widget;
          return richText.text.toPlainText().contains('Bites');
        }
        return false;
      })), findsOneWidget);

      // Step 6: Verify the presence of the description text
      await $(find.text('Lose weight, get healthy, change your habits or start a new diet plan.'))
          .waitUntilVisible();
      expect(
        $(find.text('Lose weight, get healthy, change your habits or start a new diet plan.')),
        findsOneWidget,
      );

      // Step 8: Wait for navigation to the Signinpage and verify elements on the Signinpage
      await Future.delayed(Duration(seconds: 2)); // Add a delay to allow navigation to complete

      
    },
  );
}