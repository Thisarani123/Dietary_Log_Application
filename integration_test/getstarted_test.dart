import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/Getstarted.dart'; 
import 'package:dietary_log_app/SigninPage.dart'; 

void main() {
  patrolTest(
    'Getstarted Page Test',
    ($) async {
      
      try {
        await Firebase.initializeApp();
        print("Firebase initialized successfully");
      } catch (e) {
        print("Firebase initialization failed: $e");
      }
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());
      await $.pumpWidget(MaterialApp(
        home: Getstarted(),
      ));

      await Future.delayed(Duration(seconds: 2));

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

      await $(find.text('Lose weight, get healthy, change your habits or start a new diet plan.'))
          .waitUntilVisible();
      expect(
        $(find.text('Lose weight, get healthy, change your habits or start a new diet plan.')),
        findsOneWidget,
      );

      await Future.delayed(Duration(seconds: 2)); 

      
    },
  );
}