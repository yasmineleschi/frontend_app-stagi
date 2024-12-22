import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_app_stagi/views/Home/Home_view.dart';
import 'package:frontend_app_stagi/views/authentification/signin_view.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app_stagi/viewmodels/signin_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'dart:convert';

// Mock HTTP Client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  testWidgets('E2E Login Test', (WidgetTester tester) async {
    // Initialize mock HTTP client
    final mockClient = MockHttpClient();

    // Simulate the login response from the backend
    when(mockClient.post(
      Uri.parse('http://localhost:5001/api/users/login'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(
      json.encode({
        'token': 'mockToken',
        'userId': '67616ebe3524b5a512dc290d',
        'role': 'Student',
      }),
      200,
    ));

    // Initialize SignInViewModel with mock data
    final signInViewModel = SignInViewModel();
    signInViewModel.token = 'mockToken';
    signInViewModel.userId = '67616ebe3524b5a512dc290d';
    signInViewModel.role = 'Student';

    // Wrap the SignInView in a Provider with the mocked client
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<SignInViewModel>.value(
          value: signInViewModel,
          child: SignInView(),
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

    // Verify HomeView parameters (from mock data)
    final homeView = tester.widget<HomeView>(find.byType(HomeView));
    expect(homeView.token, 'mockToken');
    expect(homeView.userId, '67616ebe3524b5a512dc290d');
    expect(homeView.role, 'Student');
  });
}
