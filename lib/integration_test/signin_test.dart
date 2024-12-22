import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/main.dart';  // Your app's main entry point
import 'package:frontend_app_stagi/views/Home/Home_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  testWidgets('E2E Login Test', (WidgetTester tester) async {
    // Launch the app
    await tester.pumpWidget(MyApp());  // This launches your app

    // Find the email and password text fields
    final emailFieldFinder = find.byType(TextField).first;
    final passwordFieldFinder = find.byType(TextField).last;

    // Enter email and password
    await tester.enterText(emailFieldFinder, 'siwarchabbi@gmail.com');
    await tester.enterText(passwordFieldFinder, '123456789');

    // Tap the login button
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(); // Wait for navigation

    // Perform the real HTTP request (login API call)
    final response = await http.post(
      Uri.parse('http://backend-app-stagi.vercel.app/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': 'siwarchabbi@gmail.com',
        'password': '123456789',
      }),
    );

    // Check if login was successful (status 200)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      expect(data['accessToken'], isNotNull);
      expect(data['userId'], isNotNull);

      // Verify navigation to HomeView
      expect(find.byType(HomeView), findsOneWidget);

      // Verify parameters passed to HomeView
      final homeViewWidget = tester.widget<HomeView>(find.byType(HomeView));
      expect(homeViewWidget.token, data['accessToken']);
      expect(homeViewWidget.userId, data['userId']);
      expect(homeViewWidget.role, 'Student');  // Adjust based on your response
    } else {
      fail('Login failed with status code: ${response.statusCode}');
    }
  });
}
