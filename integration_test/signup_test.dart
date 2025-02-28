import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/SigninPage.dart'; 
import 'package:dietary_log_app/SignupPage.dart'; 

void main() {
  patrolTest(
    'SignUpScreen functionality test',
    ($) async {
      await Firebase.initializeApp();
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());
      await $.pumpWidget(const MaterialApp(home: SignUpScreen()));

      expect($(find.text('E-MAIL:')), findsOneWidget);
      expect($(find.text('USERNAME:')), findsOneWidget);
      expect($(find.text('PASSWORD:')), findsOneWidget);

      await $(find.byType(TextField).first).enterText('invalid_email');
      await $(find.byType(TextField).at(1)).enterText(''); 
      await $(find.byType(TextField).last).enterText('short');
      await $(find.text('SIGN UP')).tap();

      expect($(find.text('Enter a valid email address')), findsOneWidget);
      expect($(find.text('Username is required')), findsOneWidget);
      expect($(find.text('Password must be at least 8 characters long')), findsOneWidget);

      await $(find.byType(TextField).first).enterText(''); 
      await $(find.byType(TextField).at(1)).enterText(''); 
      await $(find.byType(TextField).last).enterText(''); 
      await $(find.byType(TextField).first).enterText('test@example.com');
      await $(find.byType(TextField).at(1)).enterText('newuser123');
      await $(find.byType(TextField).last).enterText('password123');
      await $(find.text('Sign Up')).tap();

      await Future.delayed(const Duration(seconds: 2));

      expect($(find.text('Sign In')), findsOneWidget); 
      
      await $(find.byType(TextField).first).enterText('test@example.com');
      await $(find.byType(TextField).at(1)).enterText('newuser123');
      await $(find.byType(TextField).last).enterText('password123');
      await $(find.text('Sign Up')).tap();
      expect($(find.text('Email already exists')), findsOneWidget);
      expect($(find.text('Username already taken')), findsOneWidget);

      await $(find.text('SIGN IN HERE')).tap();
      expect($(find.text('Sign In')), findsOneWidget); 
    },
  );
}