import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Student_view.dart';
import 'package:frontend_app_stagi/views/Profil/Student/create_studentprofile_view.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend_app_stagi/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test: Student Profile Creation', () {
    testWidgets('Register, navigate, and create student profile', (WidgetTester tester) async {
      // Initialize app
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
      await tester.tap(signUpButton2);
      await tester.pumpAndSettle();

      // Verify SharedPreferences userId setup
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      expect(userId, isNotNull);

      // Navigate to ProfileStepper
      expect(find.byType(ProfileStepper), findsOneWidget);

      // Fill Basic Info form
      await tester.enterText(find.byKey(Key('firstNameField')), 'John');
      await tester.enterText(find.byKey(Key('lastNameField')), 'Doe');
      await tester.enterText(find.byKey(Key('phoneField')), '123456789');
      await tester.enterText(find.byKey(Key('bioField')), 'A passionate student.');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Fill Education form
      await tester.enterText(find.byKey(Key('degreeField')), 'Bachelor of Science');
      await tester.enterText(find.byKey(Key('institutionField')), 'University of Example');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Skip through remaining steps
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Verify navigation to StudentProfileView
      expect(find.byType(StudentProfileView), findsOneWidget);
    });
  });
}
