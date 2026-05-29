import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fe_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E App Testing - Login Flow', () {
    testWidgets('Verify Login Screen widgets and input validation', (WidgetTester tester) async {
      // Start the application
      app.main();
      await tester.pumpAndSettle();

      // Verify that we are on the login screen and see the welcoming texts
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Login to continue managing your learning'), findsOneWidget);

      // Verify that the email and password text fields are present
      final Finder emailField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Email Address',
      );
      final Finder passwordField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Password',
      );
      
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);

      // Verify that the login button is present
      final Finder loginBtn = find.text('Login');
      expect(loginBtn, findsOneWidget);

      // Scenario A: Test validation errors by clicking Login when fields are empty
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      // Verify validation error messages are displayed
      expect(find.text('Please enter email'), findsOneWidget);
      expect(find.text('Please enter password'), findsOneWidget);

      // Scenario B: Enter email and password and click login
      await tester.enterText(emailField, 'test_student@example.com');
      await tester.enterText(passwordField, '123456');
      await tester.pumpAndSettle();

      // Tap the login button again
      await tester.tap(loginBtn);
      await tester.pump(); // Triggers state change to loading

      // The app will try to hit the backend API (if running)
      // We will let the test expect either successful login or connection failure gracefully
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });
  });
}
