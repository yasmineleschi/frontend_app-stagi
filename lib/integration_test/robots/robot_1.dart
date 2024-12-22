import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class Robot1 {
  final WidgetTester tester;

  Robot1(this.tester);

  Future<void> handleInvalidLogin() async {
    await tester.enterText(find.byType(TextField).at(0), 'sirin@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), '123456789');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Check for error message
    expect(find.text('Invalid credentials'), findsOneWidget);
  }
}
