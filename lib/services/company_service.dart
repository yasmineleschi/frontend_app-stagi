import 'dart:convert';
import 'dart:io';
import 'package:frontend_app_stagi/models/company.dart';
import 'package:http/http.dart' as http;

class CompanyService {
  final String baseUrl = 'https://backend-app-stagi.vercel.app/api/companies';

  Future<Company?> fetchCompanyProfile(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fetch/$userId'));

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        print('Decoded JSON: $decodedJson');

        final companyProfileJson = decodedJson['companyProfile'];
        if (companyProfileJson != null) {
          return Company.fromJson(companyProfileJson);
        } else {
          print('Failed to load Company profile , Response: $decodedJson');
          return null;
        }
      } else {
        print('Failed to load Company profile');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> createCompanyProfile(Company company) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/createProfile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(company.toJson()),
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

  Future<bool> updateCompanyProfile(
      String userId, Company updatedProfile) async {
    try {
      final response = await http.put(Uri.parse('$baseUrl/update/$userId'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(updatedProfile.toJson()));

      if (response.statusCode == 200) {
        print('Profile updated successfully: ${response.body}');
        return true;
      } else {
        print('Failed to update profile: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating Company profile: $e');
      return false;
    }
  }


  Future<List<Internship>> fetchInternships() async {
    final url = Uri.parse('$baseUrl/internships');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");

        Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('data') && data['data'] != null) {
          List<dynamic> internshipsData = data['data'];
          return internshipsData
              .map((item) => Internship.fromJson(item))
              .toList();
        } else {
          throw Exception(
              "Internships data is missing or null in the 'data' key");
        }
      } else {
        throw Exception("Failed to fetch internships: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching internships: $e");
    }
  }

  Future<List<dynamic>> getFilteredCompanies({
    String? name,
    String? sector,
    String? address,
    String? internshipTitle,
    String? internshipDescription,
    String? internshipRequirements,

  }) async {
    final Map<String, String> queryParams = {};

    if (name != null) queryParams['name'] = name;
    if (sector != null) queryParams['sector'] = sector;
    if (address != null) queryParams['address'] = address;
    if (internshipTitle != null)
      queryParams['internshipTitle'] = internshipTitle;
    if (internshipDescription != null)
      queryParams['internshipDescription'] = internshipDescription;
    if (internshipRequirements != null)
      queryParams['internshipRequirements'] = internshipRequirements;


    final uri =
        Uri.parse('$baseUrl/search').replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load companies');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
