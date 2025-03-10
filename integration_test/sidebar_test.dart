import 'package:dietary_log_app/SigninPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';


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
      when(mockUser.email).thenReturn('test@gmail.com');
      when(mockUser.displayName).thenReturn('testuser');

      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});

      
      await $.pumpWidget(MaterialApp(
        routes: {
          '/': (context) => sidebar(
                profileImageUrl: 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.veryicon.com%2Ficons%2Finternet--web%2Fweb-interface-flat%2F6606-male-user.html&psig=AOvVaw35r47xYf9bWTKZaP0CmBlI&ust=1741417606864000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCKjinKi094sDFQAAAAAdAAAAABAJ',
                username: 'testuser',
                email: 'test@gmail.com',
              ),
          '/login': (context) => Signinpage(), 
        },
      ));

      
      await $(find.byIcon(Icons.menu)).tap();
      await $(find.text('Home')).waitUntilVisible();

      
      expect($(find.text('testuser')), findsOneWidget);
      expect($(find.text('test@gmail.com')), findsOneWidget);

      // Navigate to Add Meal page
      await $(find.text('Add Meal')).tap();
      await $(find.text('Add My Meals')).waitUntilVisible(); 

      // Navigate back to Home page
      await $(find.byIcon(Icons.menu)).tap();
      await $(find.text('Home')).tap();

      // Navigate to Profile page
      await $(find.byIcon(Icons.menu)).tap();
      await $(find.text('Profile')).tap();
      await $(find.text('User Name')).waitUntilVisible(); 

      // Test logout functionality
      await $(find.byIcon(Icons.menu)).tap();
      await $(find.text('Logout')).tap();

      // navigation to the login screen
      await Future.delayed(const Duration(seconds: 2)); 

      
      await $(find.text('E-MAIL:')).waitUntilVisible(); 
      await $(find.text('PASSWORD:')).waitUntilVisible(); 
    },
  );
}