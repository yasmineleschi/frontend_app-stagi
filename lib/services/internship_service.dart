import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/internship_application.dart';

class InternshipService {
  final String baseUrl = "http://localhost:5001/api/internshipApply";

  Future<bool> applyForInternship({

    required String internshipId,
    required String studentId,
    required String message,
    String? attachmentId,
  }) async {
    final url = Uri.parse('$baseUrl/apply');
    final body = {
      "internshipId": internshipId,
      "studentId": studentId,
      "message": message,
      if (attachmentId != null) "attachmentId": attachmentId,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return true; // Application submitted successfully
      } else {
        print("Failed to apply: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error applying for internship: $error");
      return false;
    }
  }


  Future<List<InternshipApplication>> getCompanyApplications(String companyId) async {
    final url = Uri.parse("$baseUrl/company/$companyId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body); // Correct type
      print("API Response: $data");

      return data.map((e) => InternshipApplication.fromJson(e)).toList();
    } else {
      print("Failed to fetch applications. Status code: ${response.statusCode}");
      throw Exception("Failed to fetch applications.");
    }
  }


  Future<bool> updateApplicationStatus(String applicationId, String status) async {
    final url = Uri.parse("$baseUrl/$applicationId");
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to update application status.");
    }
  }
}
