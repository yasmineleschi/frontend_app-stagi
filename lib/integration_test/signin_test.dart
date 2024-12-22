import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_app_stagi/viewmodels/signin_viewmodel.dart';
import 'package:frontend_app_stagi/views/Home/Home_view.dart';
import 'package:frontend_app_stagi/views/authentification/signin_view.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

// Mock class for the HTTP client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  testWidgets('E2E Login Test', (WidgetTester tester) async {
    // Initialize mock HTTP client
    final mockClient = MockHttpClient();

    // Simulate the login response from the backend
    when(mockClient.post(
      Uri.parse('http://localhost:5001/api/users/login'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async {
      // Simulate the response from the server
      return http.Response(
        json.encode({
          'accessToken': 'mockToken',
          'userId': '67616ebe3524b5a512dc290d',
          'role': 'Student',
        }),
        200,
      );
    });

    // Create an instance of SignInViewModel
    final signInViewModel = SignInViewModel();

    // Replace the actual HTTP client with the mock client in the ViewModel
    signInViewModel.httpClient = mockClient;

    // Wrap the SignInView in a Provider with the mocked SignInViewModel
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<SignInViewModel>.value(
          value: signInViewModel,
          child: const SignInView(),
        ),
      ),
    );

    // Wait for the UI to fully render
    await tester.pumpAndSettle();

    // Find email and password text fields
    final emailFieldFinder = find.byType(TextField).first;
    final passwordFieldFinder = find.byType(TextField).last;

    // Ensure the fields are present
    expect(emailFieldFinder, findsOneWidget);
    expect(passwordFieldFinder, findsOneWidget);

    // Enter email and password
    await tester.enterText(emailFieldFinder, 'sirin@gmail.com');
    await tester.enterText(passwordFieldFinder, '123456789');

    // Tap the login button
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify navigation to HomeView
    expect(find.byType(HomeView), findsOneWidget);

    // Verify the token, userId, and role are passed correctly (you can modify this as needed)
    expect(find.text('mockToken'), findsOneWidget);
    expect(find.text('67616ebe3524b5a512dc290d'), findsOneWidget);
    expect(find.text('Student'), findsOneWidget);
  });
}
