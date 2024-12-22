import 'dart:convert';
import 'package:http/http.dart' as http;

class InstitutionService {
  final String baseUrl = 'https://backend-app-stagi.vercel.app/api/institutions';

  Future<List<String>> fetchInstitutions(String query) async {
    if (query.isEmpty) return [];

    final response = await http.get(Uri.parse('$baseUrl/getinstitutions?name=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((institution) => institution['name'] as String).toList();
    } else {
      throw Exception('Failed to load institutions');
    }
  }

}
