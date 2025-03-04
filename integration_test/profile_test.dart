import 'package:dietary_log_app/HomePage.dart';
import 'package:dietary_log_app/profile_setting.dart'; 
import 'package:dietary_log_app/sidebar.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('Profile Setting Page Test', ($) async {
    await Firebase.initializeApp();
    PatrolBinding.ensureInitialized(NativeAutomatorConfig());

    await $.pumpWidgetAndSettle(MaterialApp(
      home: profilesetting(),
    ));

    await $(find.byType(TextField).at(0)).enterText('John Doe');
    await $(find.byType(TextField).at(1)).enterText('john.doe@example.com');
    await $(find.byType(TextField).at(2)).enterText('1234567890');
    await $(find.byType(TextField).at(3)).enterText('password123');

    await $(find.text('UPDATE')).tap();
  });
}
