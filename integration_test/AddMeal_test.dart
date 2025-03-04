import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/AddMeal.dart';

void main() {
  patrolTest(
    'AddMealScreen functionality test',
    ($) async {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Initialize Patrol with NativeAutomatorConfig
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());

      // Start the app with AddMealScreen as the home widget
      await $.pumpWidget(MaterialApp(
        home: AddMealScreen(
          onSave: (mealType, calories, carbs, protein, fat) {
            // Mock callback function
            print('Meal saved: $mealType, $calories, $carbs, $protein, $fat');
          },
        ),
      ));

      // Verify the title of the page
      expect($(find.text('Add My Meals')), findsOneWidget);

      // Enter text into the form fields
      await $(find.byType(TextField).first).enterText('Pizza'); // Food Name
      await $(find.byType(TextField).at(1)).enterText('300');   // Calories
      await $(find.byType(TextField).at(2)).enterText('40.0');  // Carbs
      await $(find.byType(TextField).at(3)).enterText('10.0');  // Protein
      await $(find.byType(TextField).at(4)).enterText('15.0');  // Fat

      // Select meal type from the dropdown
      await $(find.byKey(const Key('mealTypeDropdown'))).tap();
      await $(find.text('Lunch')).tap();

      // Select a date
      await $(find.byIcon(Icons.calendar_today)).tap();
      await $(find.text('OK')).tap(); // Confirm the date picker

      // Select a time
      await $(find.byIcon(Icons.access_time)).tap();
      await $(find.text('OK')).tap(); // Confirm the time picker

      // Tap the Save Meal button
      await $(find.text('Save Meal')).tap();

      // Wait for navigation to DietaryLogPage
      await $(find.text('HELLO,')).waitUntilVisible();

     
      

      // // Verify navigation to the next screen
      // expect(find.byType(sidebar), findsOneWidget);
    },
  );
}