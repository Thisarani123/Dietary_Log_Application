import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/SigninPage.dart'; // Ensure this path is correct
import 'package:dietary_log_app/sidebar.dart'; // Ensure this path is correct

void main() {
  patrolTest(
    'Signinpage functionality test',
    ($) async {
      // Initialize Patrol with NativeAutomatorConfig
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());

      // Start the app with Signinpage as the home widget
      await $.pumpWidget(const MaterialApp(home: Signinpage()));

      // Verify that the Signinpage is displayed
      expect($(find.text('E-MAIL:')), findsOneWidget);
      expect($(find.text('PASSWORD:')), findsOneWidget);

      // Enter invalid email and password
      await $(find.byType(TextField).first).enterText('invalid_email');
      await $(find.byType(TextField).last).enterText('short');

      // Tap the "Sign In" button
      await $(find.text('Sign In')).tap();

      // Verify error messages for invalid input
      expect($(find.text('Enter a valid email address')), findsOneWidget);
      expect($(find.text('Password must be at least 8 characters long')), findsOneWidget);

      // Clear the fields and enter valid email and password
      await $(find.byType(TextField).first).enterText(''); // Clear email field
      await $(find.byType(TextField).last).enterText(''); // Clear password field
      await $(find.byType(TextField).first).enterText('test@example.com');
      await $(find.byType(TextField).last).enterText('password123');

      // Tap the "Sign In" button again
      await $(find.text('Sign In')).tap();

      // Wait for navigation to the sidebar page
      await Future.delayed(const Duration(seconds: 2));

      // Verify that the app navigates to the sidebar page
      expect($(find.text('Welcome!')), findsOneWidget); // Replace 'Welcome!' with actual text on the sidebar page

      // Test "Forgot Password?" functionality
      await $(find.text('Forgot Password?')).tap();
      await $(find.byType(TextField).first).enterText('test@example.com');
      await $(find.text('Send Reset Email')).tap(); // Replace with actual button text if different
      expect($(find.text('Password reset email sent.')), findsOneWidget);

      // Test "Remember Me" checkbox
      await $(find.byType(Checkbox)).tap();
      expect($(find.byType(Checkbox)), findsOneWidget);

      // Test "Sign Up Here" link
      await $(find.text('SIGN UP HERE')).tap();
      expect($(find.text('Sign Up')), findsOneWidget); // Replace 'Sign Up' with actual text on the signup page
    },
  );
}