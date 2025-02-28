import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:dietary_log_app/Splashpage.dart'; 
import 'package:dietary_log_app/GetStarted.dart'; 

void main() {
  patrolTest(
    'Splashpage navigates to Getstarted after 4 seconds',
    ($) async {
     
      PatrolBinding.ensureInitialized(NativeAutomatorConfig());
      await $.pumpWidget(const MaterialApp(home: Splashpage()));
      expect($(find.byKey(const Key('splash_rich_text'))), findsOneWidget);
      expect($(find.byKey(const Key('splash_logo'))), findsOneWidget);
      await Future.delayed(const Duration(seconds: 4));

    },
  );
}