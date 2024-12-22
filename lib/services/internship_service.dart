import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/internship_application.dart';

class InternshipService {

  final String baseUrl = "https://backend-app-stagi.vercel.app/api/internshipApply";

  Future<bool> applyForInternship({ required String internshipId, required String studentId, required String message, String? attachmentId, String? internshipTitle, }) async {
    final url = Uri.parse('$baseUrl/apply');
    final body = {
      "internshipId": internshipId,
      "studentId": studentId,
      "message": message,
      if (attachmentId != null) "attachmentId": attachmentId,
      if (internshipTitle != null) "internshipTitle": internshipTitle,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return true;
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
      final List<dynamic> data = jsonDecode(response.body);
      print("API Response: $data");

      return data.map((e) => InternshipApplication.fromJson(e)).toList();
    } else {
      print("Failed to fetch applications. Status code: ${response.statusCode}");
      throw Exception("Failed to fetch applications.");
    }
  }

  Future<List<InternshipApplication>> getStudentApplications(String studentId) async {
    final url = Uri.parse("$baseUrl/student/$studentId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("API Response: $data");
      return data.map((app) => InternshipApplication.fromJson(app)).toList();
    } else {
      print("Failed to fetch applications: ${response.statusCode} ${response.body}");
      throw Exception("Failed to fetch applications.");
    }
  }

  Future<bool> updateApplicationStatus( String applicationId, String status, { DateTime? interviewDate,}) async {
    final url = Uri.parse("$baseUrl/$applicationId");
    final body = {
      'status': status,
      if (interviewDate != null) 'interviewDate': interviewDate.toIso8601String(),
    };

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Failed to update status: ${response.body}");
      throw Exception("Failed to update application status.");
    }
  }

}
