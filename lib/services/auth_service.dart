import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  final String baseUrl = 'http://localhost:5001/api/users';


  Future<String> signUp(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode(<String, String>{
        'username': user.username,
        'email': user.email,
        'password': user.password,
        'role': user.role,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      print("User registered successfully");
      final data = json.decode(response.body);

      return data['_id'];

    } else {
      final errorData = jsonDecode(response.body);
      throw Exception("Failed to sign up: ${errorData['message']}");

    }
  }

}
