import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  final String baseUrl = 'https://backend-app-stagi.vercel.app/api';


  Future<List<dynamic>> fetchPublications(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/publications'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch publications');
    }
  }

  Future<void> createPublication(String token, String title, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/publications'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'title': title, 'content': content}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create publication');
    }
  }
}
