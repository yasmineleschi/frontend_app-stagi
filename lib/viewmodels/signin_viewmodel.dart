import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding

class SignInViewModel extends ChangeNotifier {
  final String backendUrl = 'http://localhost:5000/api/users/login'; // Replace with your backend URL
  String email = '';
  String password = '';
  String errorMessage = '';
  bool isLoading = false;
  String token = ''; // Store token
  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<void> signIn() async {
    if (email.isEmpty || password.isEmpty) {
      errorMessage = "Email and password are required!";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
         token = data['accessToken']; // JWT token from backend

        // Optionally store token for later use
        errorMessage = '';
      } else {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? 'Login failed';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
