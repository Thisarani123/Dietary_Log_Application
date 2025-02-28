import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/SigninPage.dart'; 
import 'package:dietary_log_app/sidebar.dart'; 
import 'package:dietary_log_app/SignupPage.dart';

void main() {
  patrolTest(
    'Signinpage functionality test',
    ($) async {
      await Firebase.initializeApp();
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());
      await $.pumpWidget(const MaterialApp( home: Signinpage()));

      expect($(find.text('E-MAIL:')), findsOneWidget);
      expect($(find.text('PASSWORD:')), findsOneWidget);

      await $(find.byType(TextField).first).enterText('test5@gmail.com');
      await $(find.byType(TextField).last).enterText('password123');
      await $(find.text('LOGIN')).tap(); 

      expect($(find.text('Enter a valid email address')), findsOneWidget);
      expect($(find.text('Password must be at least 8 characters long')), findsOneWidget);

      await $(find.byType(TextField).first).enterText("");
      await $(find.byType(TextField).last).enterText("");
      await $(find.byType(TextField).first).enterText('test@gmail.com');
      await $(find.byType(TextField).last).enterText('password123');
      await $(find.text('LOGIN')).tap(); 

      await $(find.text('Welcome!')).waitUntilVisible(); 

      await $(find.text('Forgot Password?')).tap();
      await $(find.byType(TextField).first).enterText('test5@gmail.com');
      await $(find.text('Send Reset Email')).tap(); 
      expect($(find.text('Password reset email sent.')), findsOneWidget);

      await $(find.byType(Checkbox)).tap();
      expect($(find.byType(Checkbox)), findsOneWidget);

      await $(find.text('SIGN UP HERE')).tap();
      expect($(find.text('Sign Up')), findsOneWidget); 
      
      await $(find.byType(TextField).first).enterText('newuser@example.com');
      await $(find.byType(TextField).at(1)).enterText('newusername');
      await $(find.byType(TextField).last).enterText('newpassword123');
      await $(find.text('Sign Up')).tap();

      await $(find.text('LOGIN')).waitUntilVisible(); 

    
    },
  );
}