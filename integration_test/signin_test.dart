import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/SigninPage.dart'; // Ensure this import is correct
import 'package:dietary_log_app/sidebar.dart'; // Ensure this import is correct

void main() {
  patrolTest(
    'Signin Page Test',
    ($) async {
      // Step 1: Initialize Firebase
      try {
        print("Attempting to initialize Firebase...");
        await Firebase.initializeApp();
        print("Firebase initialized successfully");
      } catch (e) {
        print("Firebase initialization failed: $e");
        fail("Firebase initialization failed. Cannot proceed with the test.");
      }

      // Step 2: Initialize Patrol with NativeAutomatorConfig
      print("Initializing Patrol with NativeAutomatorConfig...");
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());
      print("Patrol initialized successfully");

      // Step 3: Start the app with Signinpage as the home widget
      print("Pumping the SigninPage widget...");
      await $.pumpWidget(MaterialApp(
        home: Signinpage(),
      ));
      print("SigninPage widget pumped successfully");

      // Step 4: Verify initial UI elements
      print("Verifying presence of 'E-MAIL:' text...");
      await $(find.text('E-MAIL:')).waitUntilVisible(timeout: Duration(seconds: 5));
      expect($(find.text('E-MAIL:')), findsOneWidget);
      print("'E-MAIL:' text found successfully");

      print("Verifying presence of 'PASSWORD:' text...");
      await $(find.text('PASSWORD:')).waitUntilVisible(timeout: Duration(seconds: 5));
      expect($(find.text('PASSWORD:')), findsOneWidget);
      print("'PASSWORD:' text found successfully");

      print("Verifying presence of Checkbox widget...");
      await $(find.byType(Checkbox)).waitUntilVisible(timeout: Duration(seconds: 5));
      expect($(find.byType(Checkbox)), findsOneWidget);
      print("Checkbox widget found successfully");

      print("Verifying presence of 'Forgot Password?' text...");
      await $(find.text('Forgot Password?')).waitUntilVisible(timeout: Duration(seconds: 5));
      expect($(find.text('Forgot Password?')), findsOneWidget);
      print("'Forgot Password?' text found successfully");

      // Step 5: Enter email and password
      print("Entering email into the first TextField...");
      await $(find.byType(TextField).at(0)).enterText('paraminavodani@gmail.com');
      print("Email entered successfully");

      print("Entering password into the second TextField...");
      await $(find.byType(TextField).at(1)).enterText('password123');
      print("Password entered successfully");

      // Tap the LOGIN button
      print("Tapping the LOGIN button...");
      await $(find.text('LOGIN')).tap();
      print("LOGIN button tapped successfully");

      await $(find.text('HELLO,')).waitUntilVisible();
      expect($(find.text('HELLO,')), findsOneWidget);


      
      }
  
  );
}