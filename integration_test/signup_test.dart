import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_app_stagi/views/Profil/Company/create_companyprofile_view.dart';
import 'package:frontend_app_stagi/views/Profil/Student/create_studentprofile_view.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend_app_stagi/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SignUp E2E Test', () {
    testWidgets('Sign up as a new user', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to SignUp screen if needed
      final signUpButton = find.text('Sign Up Now');
      if (signUpButton.evaluate().isNotEmpty) {
        await tester.tap(signUpButton);
        await tester.pumpAndSettle();
      }

      // Verify the presence of username field
      final usernameField = find.byKey(const Key('usernameField'));
      expect(usernameField, findsOneWidget);
      await tester.enterText(usernameField, 'testuser');

      // Verify the presence of email field
      final emailField = find.byKey(const Key('emailField'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'testuser@example.com');

      // Verify the presence of password field
      final passwordField = find.byKey(const Key('passwordField'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, 'password123');

      // Interact with the role dropdown
      final roleDropdown = find.byKey(const Key('roleDropdown'));
      expect(roleDropdown, findsOneWidget);  // Ensure the widget exists
      await tester.tap(roleDropdown);
      await tester.pumpAndSettle();
      final roleOption = find.text('Student').last; // Ensure this matches the role you want to test
      await tester.tap(roleOption);
      await tester.pumpAndSettle();

      // Tap the Sign Up button
      final signUpButton2 = find.byKey(const Key('signUpButton'));
      expect(signUpButton2, findsOneWidget);
      await tester.tap(signUpButton2);
      await tester.pumpAndSettle();


      // Check for navigation to the appropriate screen based on the role
      if (roleOption.evaluate().first.widget is Text && (roleOption.evaluate().first.widget as Text).data == 'Student') {
        // Check for the ProfileStepper screen (Student)
        final profileStepperWidget = find.byType(ProfileStepper);
        expect(profileStepperWidget, findsOneWidget);
      } else if (roleOption.evaluate().first.widget is Text && (roleOption.evaluate().first.widget as Text).data == 'Company') {
        // Check for the CompanyProfileStepper screen (Company)
        final companyProfileStepperWidget = find.byType(CompanyProfileStepper);
        expect(companyProfileStepperWidget, findsOneWidget);
      }
    });
  });
}
