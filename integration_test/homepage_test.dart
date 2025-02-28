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
      await Firebase.initializeApp();
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());
      await $.pumpWidget(MaterialApp(home: DietaryLogPage()));

      expect($(find.text('HELLO,')), findsOneWidget);
      expect($(find.textContaining('kcal')), findsOneWidget);

      await $(find.text('Add My Meals')).tap();
      await $(find.byType(TextField).first).enterText('Burger'); 
      await $(find.byType(TextField).at(1)).enterText('500'); 
      await $(find.byType(TextField).at(2)).enterText('60.0'); 
      await $(find.byType(TextField).at(3)).enterText('20.0'); 
      await $(find.byType(TextField).at(4)).enterText('25.0'); 

      await $(find.byKey(const Key('mealTypeDropdown'))).waitUntilVisible();
      await $(find.byKey(const Key('mealTypeDropdown'))).tap();
      await $(find.text('Dinner')).tap();

      await $(find.byIcon(Icons.calendar_today)).tap();
      await $(find.text('OK')).tap(); 

      await $(find.byIcon(Icons.access_time)).tap();
      await $(find.text('OK')).tap(); 

      await $(find.text('Save Meal')).tap();

      await Future.delayed(const Duration(seconds: 5)); 
      await $(find.textContaining('500 kcal')).waitUntilVisible();

      await $(find.text('Dinner')).waitUntilVisible();
      await $(find.textContaining('Calories: 500')).waitUntilVisible();

      await $(find.byIcon(Icons.calendar_today)).tap();
      await $(find.text('OK')).tap(); 
    },
  );
}