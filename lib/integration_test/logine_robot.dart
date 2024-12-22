import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

class LoginRobot {
  final WidgetTester tester;

  LoginRobot(this.tester);

  Future<void> enterEmail(String email) async {
    final emailField = find.byType(TextField).at(0); // Assuming email is the first field
    await tester.enterText(emailField, email);
    await tester.pumpAndSettle();
  }

  Future<void> enterPassword(String password) async {
    final passwordField = find.byType(TextField).at(1); // Assuming password is the second field
    await tester.enterText(passwordField, password);
    await tester.pumpAndSettle();
  }

  Future<void> tapLoginButton() async {
    final loginButton = find.text('Login');
    await tester.ensureVisible(loginButton); // Scroll to make the widget visible
    await tester.tap(loginButton);
    await tester.pumpAndSettle(); // Wait for animations and transitions to complete
  }

}
