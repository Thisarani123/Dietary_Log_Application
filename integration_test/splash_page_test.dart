import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/Splashpage.dart'; // Ensure this path is correct
import 'package:dietary_log_app/GetStarted.dart'; // Ensure this path is correct

void main() {
  patrolTest(
    'Splashpage navigates to Getstarted after 4 seconds',
    ($) async {
      // Initialize Patrol with NativeAutomatorConfig
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());

      // Start the app with Splashpage as the home widget
      await $.pumpWidget(const MaterialApp(home: Splashpage()));

      // Verify that the Splashpage is displayed
      expect($(find.byKey(const Key('splash_rich_text'))), findsOneWidget);

      // Verify that the logo.png image is displayed
      expect($(find.byKey(const Key('splash_logo'))), findsOneWidget);

      // Wait for 4 seconds to ensure navigation happens
      await Future.delayed(const Duration(seconds: 4));

    },
  );
}