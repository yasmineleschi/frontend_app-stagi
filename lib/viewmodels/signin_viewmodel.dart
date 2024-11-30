import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SignInViewModel extends ChangeNotifier {
  final String backendUrl = 'http://10.0.2.2:5001/api/users/login';  // Your backend URL
  String email = '';
  String password = '';
  String errorMessage = '';
  bool isLoading = false;
  String token = '';
  String userId = '';
  String role = 'Student';

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<void> saveUserData(String token, String userId, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', userId);
    await prefs.setString('role', role);
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
        token = data['accessToken'];
        userId = data['userId'];
        role = data['role'];


        await saveUserData(token, userId, role);

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


  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    userId = prefs.getString('userId') ?? '';
    role = prefs.getString('role') ?? 'Student';
    notifyListeners();
  }
}
