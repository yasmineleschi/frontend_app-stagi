import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  String username = '';
  String email = '';
  String password = '';
  String errorMessage = '';

  void setUsername(String value) {
    username = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }
  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<void> signUp() async {
    try {
      User user = User(username: username, email: email, password: password);
      await _apiService.signUp(user);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}