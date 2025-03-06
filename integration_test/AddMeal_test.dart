import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/AddMeal.dart';

void main() {
  patrolTest(
    'AddMealScreen functionality test',
    ($) async {
      
      await Firebase.initializeApp();
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());

      await $.pumpWidget(MaterialApp(
        home: AddMealScreen(
          onSave: (mealType, calories, carbs, protein, fat) {
            
            print('Meal saved: $mealType, $calories, $carbs, $protein, $fat');
          },
        ),
      ));

      expect($(find.text('Add Meal')), findsOneWidget);

      await $(find.byType(TextField).first).enterText('Pizza'); 
      await $(find.byType(TextField).at(1)).enterText('300');   
      await $(find.byType(TextField).at(2)).enterText('40.0');  
      await $(find.byType(TextField).at(3)).enterText('10.0');  
      await $(find.byType(TextField).at(4)).enterText('15.0');  
      await $(find.byKey(const Key('mealTypeDropdown'))).tap();
      await $(find.text('Lunch')).tap();

      await $(find.byIcon(Icons.calendar_today)).tap();
      await $(find.text('OK')).tap(); 

      await $(find.byIcon(Icons.access_time)).tap();
      await $(find.text('OK')).tap(); 

      await $(find.text('Save Meal')).tap();

      await $(find.text('HELLO,')).waitUntilVisible();

    
      
    },
  );
}

// expect(find.byType(sidebar), findsOneWidget);