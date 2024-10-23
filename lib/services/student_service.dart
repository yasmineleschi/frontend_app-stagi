import 'dart:convert';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://10.0.2.2:5001/api/users/profile';

  Future<StudentProfile?> fetchStudentProfile(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getProfile/$userId'));

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        print('Decoded JSON: $decodedJson');


        final studentProfileJson = decodedJson['studentProfile'];
        if (studentProfileJson != null) {
          return StudentProfile.fromJson(studentProfileJson);
        } else {
          print('Failed to load student profile , Response: $decodedJson');
          return null;
        }
      } else {
        print('Failed to load student profile');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
  Future<bool> createStudentProfile(StudentProfile studentProfile) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/createProfile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(studentProfile.toJson()),
      );

      if (response.statusCode == 201) {
        print('Profile created successfully : ${response.body}');
        return true;
      } else {
        print('Failed to create profile: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> updateStudentProfile(String userId, StudentProfile updatedProfile) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/modifierProfile/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'firstName': updatedProfile.firstName,
          'lastName': updatedProfile.lastName,
          'specialite': updatedProfile.specialite,
          'location': updatedProfile.location,
          'phone': updatedProfile.phone,
          'bio': updatedProfile.bio,
          'education': updatedProfile.education.map((edu) => edu.toJson()).toList(),  // assuming education has a `toJson()` method
          'skills': updatedProfile.skills,
          'experience': updatedProfile.experience,
        }),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully: ${response.body}');
        return true;
      } else {
        print('Failed to update profile: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating student profile: $e');
      return false;
    }
  }

}


