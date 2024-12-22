import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_app_stagi/models/user.dart';
import 'package:frontend_app_stagi/views/Profil/Company/create_companyprofile_view.dart';
import 'package:frontend_app_stagi/views/Profil/Student/create_studentprofile_view.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend_app_stagi/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test', () {
    testWidgets('Sign up as a new user and navigate to create profile page', (WidgetTester tester) async {
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

      // Select "Student" or "Company" role
      final selectedRole = 'Student'; // Change to 'Company' to test Company flow
      final roleOption = find.text(selectedRole).last;
      await tester.tap(roleOption);
      await tester.pumpAndSettle();

      // Tap the Sign Up button
      final signUpButton2 = find.byKey(const Key('signUpButton'));
      expect(signUpButton2, findsOneWidget);

      print('Pressing Sign Up button...');
      await tester.tap(signUpButton2);
      await tester.pumpAndSettle();
      print('Sign Up button pressed successfully.');

      // Wait for async operations
      await Future.delayed(const Duration(seconds: 2));


      // Check if the userId was saved in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      expect(userId, isNotNull, reason: "userId should be saved in SharedPreferences.");

      // Navigate and validate based on role
      await tester.pumpAndSettle(); // Ensure the page has settled after navigation
      if (selectedRole == 'Student') {
        expect(find.byType(ProfileStepper), findsOneWidget);
        final profileStepperWidget = tester.widget<ProfileStepper>(find.byType(ProfileStepper));
        expect(profileStepperWidget.userId, userId);
      } else if (selectedRole == 'Company') {
        expect(find.byType(CompanyProfileStepper), findsOneWidget);
        final companyProfileStepperWidget = tester.widget<CompanyProfileStepper>(find.byType(CompanyProfileStepper));
        expect(companyProfileStepperWidget.userId, userId);
      }
    });
  });
}
