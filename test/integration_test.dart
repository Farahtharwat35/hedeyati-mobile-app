
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedeyati/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login integration test', (WidgetTester tester) async {
    await app.main();

    await tester.pumpAndSettle();

    final emailField = find.byKey(const Key('email_field'));
    final passwordField = find.byKey(const Key('password_field'));
    final loginButton = find.byKey(const Key('login_button'));

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await tester.enterText(emailField, 'may@gmail.com');
    await tester.enterText(passwordField, '@may25');
    await tester.tap(loginButton);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    final homeScreen = find.byIcon(Icons.home);
    expect(homeScreen, findsAny);


    final searchField = find.byKey(const Key('search_bar'));


    expect(searchField, findsOneWidget);


    await tester.enterText(searchField, 'azza');


    await tester.pumpAndSettle();


    await Future.delayed(const Duration(seconds: 10));


    final notFound = find.text('No friends found.');
    expect(notFound, findsOneWidget);

    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 10));

    final eventScreen = find.byIcon(Icons.calendar_month);
    await tester.tap(eventScreen);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 10));

    expect(eventScreen, findsOneWidget);

    final eventName = find.text('My Weddinggg');
    expect(eventName, findsOneWidget);

    final othersEvent = find.text('Others Events');
    await tester.tap(othersEvent);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 30));

    expect(othersEvent, findsOneWidget);

    final firendsEvents = find.text('Friends Events');
    expect(firendsEvents, findsOneWidget);
  });
}