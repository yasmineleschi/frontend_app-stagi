// publication_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublicationViewModel extends ChangeNotifier {
  final String backendUrl = 'http://localhost:5000/api/publications';
  List<dynamic> publications = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchPublications(String token) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse(backendUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        publications = json.decode(response.body);
      } else {
        errorMessage = 'Failed to load publications';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPublication(String token, String title, String content) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'title': title, 'content': content}),
      );

      if (response.statusCode == 201) {
        fetchPublications(token); // Refresh the publications
      } else {
        errorMessage = 'Failed to create publication';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
