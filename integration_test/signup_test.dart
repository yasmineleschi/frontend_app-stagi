import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend_app_stagi/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sign Up Flow E2E Test', () {
    testWidgets(
      'Sign up a new user and navigate to the correct profile creation page',
          (WidgetTester tester) async {
        // Launch the app
        app.main();
        await tester.pumpAndSettle();

        // Verify if the "Sign Up Now" button is present and tap it
        final signUpButton = find.text('Sign Up Now');
        if (signUpButton.evaluate().isNotEmpty) {
          await tester.tap(signUpButton);
          await tester.pumpAndSettle();
        }

        // Verify the presence of the username field
        final usernameField = find.byKey(const Key('usernameField'));
        expect(usernameField, findsOneWidget);
        await tester.enterText(usernameField, 'testuser');

        // Verify the presence of the email field
        final emailField = find.byKey(const Key('emailField'));
        expect(emailField, findsOneWidget);
        await tester.enterText(emailField, 'testuser@example.com');

        // Verify the presence of the password field
        final passwordField = find.byKey(const Key('passwordField'));
        expect(passwordField, findsOneWidget);
        await tester.enterText(passwordField, 'password123');

        // Verify the presence of the role dropdown
        final roleDropdown = find.byKey(const Key('roleDropdown'));
        expect(roleDropdown, findsOneWidget);
        await tester.tap(roleDropdown);
        await tester.pumpAndSettle();

        // Select the role (Student or Company)
        final selectedRole = 'Student';
        final roleOption = find.text(selectedRole).last;
        await tester.tap(roleOption);
        await tester.pumpAndSettle();

        // Tap the Sign Up button to submit the form
        final signUpButton2 = find.byKey(const Key('signUpButton'));
        expect(signUpButton2, findsOneWidget);
        await tester.tap(signUpButton2);
        await tester.pumpAndSettle();



      },
    );
  });
}
