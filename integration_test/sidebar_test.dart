import 'package:dietary_log_app/SigninPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

// Mock FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}

void main() {
  patrolTest(
    'Sidebar Page Test',
    ($) async {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Initialize Patrol with NativeAutomatorConfig
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());

      // Mock Firebase Auth
      final mockAuth = MockFirebaseAuth();
      final mockUser = MockUser();
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.email).thenReturn('thisaranikaushalya5@gmail.com');
      when(mockUser.displayName).thenReturn('Test User');

      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});

      // Start the app with Sidebar as the home widget
      await $.pumpWidget(MaterialApp(
        routes: {
          '/': (context) => sidebar(
                profileImageUrl: 'https://via.placeholder.com/150',
                username: 'Test User',
                email: 'thisaranikaushalya5@gmail.com',
              ),
          '/login': (context) => Signinpage(), // Ensure this route is defined
        },
      ));

      // Open the drawer
      await $(find.byIcon(Icons.menu)).tap();
      await $(find.text('Home')).waitUntilVisible();

      // Verify profile information in the DrawerHeader
      expect($(find.text('Test User')), findsOneWidget);
      expect($(find.text('thisaranikaushalya5@gmail.com')), findsOneWidget);

      // Navigate to Add Meal page
      await $(find.text('Add Meal')).tap();
      await $(find.text('Add My Meals')).waitUntilVisible(); // Ensure this text exists on the AddMealScreen

      // Navigate back to Home page
      await $(find.byIcon(Icons.menu)).tap();
      await $(find.text('Home')).tap();

      // Navigate to Profile page
      await $(find.byIcon(Icons.menu)).tap();
      await $(find.text('Profile')).tap();
      await $(find.text('User Name')).waitUntilVisible(); // Ensure this text exists on the ProfileSetting page

      // Test logout functionality
      await $(find.byIcon(Icons.menu)).tap();
      await $(find.text('Logout')).tap();

      // Wait for navigation to the login screen
      await Future.delayed(const Duration(seconds: 2)); // Add a delay to allow navigation to complete

      // Verify that the login screen is displayed
      await $(find.text('E-MAIL:')).waitUntilVisible(); // Updated to match the actual text on the Signinpage
      await $(find.text('PASSWORD:')).waitUntilVisible(); // Updated to match the actual text on the Signinpage
    },
  );
}