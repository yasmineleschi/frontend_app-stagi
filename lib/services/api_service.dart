import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:5000/api/users';

  Future<void> signUp(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode({
        'username': user.username,
        'email': user.email,
        'password': user.password,
      }),
      headers: {'Content-Type': 'application/json'},
    );


    if (response.statusCode == 201) {
      print("User registered successfully");
    } else {

      final errorData = jsonDecode(response.body);
      throw Exception("Failed to sign up: ${errorData['message']}");
    }
  }
}
