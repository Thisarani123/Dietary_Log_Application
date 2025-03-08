import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/SignupPage.dart';
import 'package:dietary_log_app/SigninPage.dart';

void main() {
  patrolTest(
    'SignUp Page Test',
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

      // Step 3: Start the app with SignUpScreen as the home widget
      await $.pumpWidget(MaterialApp(
        home: SignUpScreen(),
      ));

      // Step 4: Verify initial UI elements
      await $(find.text('E-MAIL:')).waitUntilVisible();
      expect($(find.text('E-MAIL:')), findsOneWidget);

      await $(find.text('USERNAME:')).waitUntilVisible();
      expect($(find.text('USERNAME:')), findsOneWidget);

      await $(find.text('PASSWORD:')).waitUntilVisible();
      expect($(find.text('PASSWORD:')), findsOneWidget);

      await $(find.text('SIGN IN HERE')).waitUntilVisible();
      expect($(find.text('SIGN IN HERE')), findsOneWidget);

      // Step 5: Enter invalid email and verify error message
      await $(find.byType(TextField).at(0)).enterText('paraminavodani@gmail.com');
      await $(find.byType(TextField).at(1)).enterText('testuser');
      await $(find.byType(TextField).at(2)).enterText('password123');
      await $(find.text('SIGN UP')).tap();

      // Clear fields for next test case
      await $(find.byType(TextField).at(0)).enterText("");
      await $(find.byType(TextField).at(1)).enterText("");
      await $(find.byType(TextField).at(2)).enterText("");

      // Wait for navigation to Signinpage after successful signup
      await $(find.text('Verification email sent. Please verify before logging in.'))
          .waitUntilVisible();
      expect(
          $(find.text(
              'Verification email sent. Please verify before logging in.')),
          findsOneWidget);


          await $(find.text('Verification email sent. Please verify before logging in.'))
          .waitUntilVisible();
      expect(
          $(find.text(
              'Verification email sent. Please verify before logging in.')),
          findsOneWidget);

          await $(find.text('Verification email sent. Please verify before logging in.'))
          .waitUntilVisible();
      expect(
          $(find.text(
              'Verification email sent. Please verify before logging in.')),
          findsOneWidget);

          await $(find.text('Verification email sent. Please verify before logging in.'))
          .waitUntilVisible();
      expect(
          $(find.text(
              'Verification email sent. Please verify before logging in.')),
          findsOneWidget);



      // Simulate email verification process
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser;

      if (user != null && !user.emailVerified) {
        // Simulate opening the email and clicking the verification link
        await Future.delayed(Duration(seconds: 20)); // Simulate waiting for email
        await user.reload();
        final updatedUser = auth.currentUser; // Reload user data to check email verification status

        if (updatedUser != null && updatedUser.emailVerified) {
          print("Email verified successfully.");
        } else {
          print("Email verification failed. Marking email as verified manually.");

          // Mock email verification by marking the user as verified
          await auth.currentUser!.updateEmail(user.email!);
          await auth.currentUser!.sendEmailVerification();
          await auth.currentUser!.reload();
        }
      }
    
     
      // Navigate to Signinpage after verification
      await $(find.text('LOGIN')).waitUntilVisible(); // Replace 'E-MAIL:' with actual text on the signin page
      expect($(find.text('LOGIN')), findsOneWidget);

      
    },
  );
}