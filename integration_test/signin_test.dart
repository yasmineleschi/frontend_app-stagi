import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend_app_stagi/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login E2E Test', () {
    testWidgets('Login with valid credentials', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify the presence of email field
      final emailField = find.byKey(const Key('usernameField'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'malekeleschi011@gmail.com');

      // Verify the presence of password field
      final passwordField = find.byKey(const Key('passwordField'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, '123456789');

      // Tap the Login button
      final loginSubmitButton = find.text('Login');
      expect(loginSubmitButton, findsOneWidget);
      await tester.tap(loginSubmitButton);
      await tester.pumpAndSettle();


    });

  });
}
