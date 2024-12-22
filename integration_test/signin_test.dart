import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend_app_stagi/main.dart' as app;
import 'package:frontend_app_stagi/views/Home/Home_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login E2E Test', () {
    testWidgets('Login with valid credentials', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Login screen if needed
      final loginButton = find.text('Login');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton);
        await tester.pumpAndSettle();
      }

      // Verify the presence of email field
      final emailField = find.byKey(const Key('usernameField'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'sirin@gmail.com');

      // Verify the presence of password field
      final passwordField = find.byKey(const Key('passwordField'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, '123456789');

      // Tap the Login button
      final loginSubmitButton = find.text('Login');
      expect(loginSubmitButton, findsOneWidget);
      await tester.tap(loginSubmitButton);
      await tester.pumpAndSettle();

      // Check for navigation to the Home screen
      final homeScreen = find.byType(HomeView);
      expect(homeScreen, findsOneWidget);
    });

    testWidgets('Login with invalid credentials', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Login screen if needed
      final loginButton = find.text('Login');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton);
        await tester.pumpAndSettle();
      }

      // Enter invalid email and password
      final emailField = find.byKey(const Key('usernameField'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'invaliduser@example.com');

      final passwordField = find.byKey(const Key('passwordField'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, 'wrongpassword');

      // Tap the Login button
      final loginSubmitButton = find.text('Login');
      expect(loginSubmitButton, findsOneWidget);
      await tester.tap(loginSubmitButton);
      await tester.pumpAndSettle();

      // Verify the error message is displayed
      final errorMessage = find.textContaining('Login failed');
      expect(errorMessage, findsOneWidget);
    });
  });
}
