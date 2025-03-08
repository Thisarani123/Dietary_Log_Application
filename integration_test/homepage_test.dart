import 'package:dietary_log_app/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/AddMeal.dart';

void main() {
  patrolTest(
    'DietaryLogPage functionality test',
    ($) async {
      // Initialize Firebase
      await Firebase.initializeApp();
      
      // Initialize Patrol with NativeAutomatorConfig
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());

      // Start the app with DietaryLogPage as the home widget
      await $.pumpWidget(MaterialApp(home: DietaryLogPage()));

      // Verify the header and calorie indicator
      expect($(find.text('HELLO,')), findsOneWidget);
      expect($(find.textContaining('kcal')), findsOneWidget);

      // Tap the Add Meal button
      await $(find.text('Add Meal')).tap();

     
    },
  );
}