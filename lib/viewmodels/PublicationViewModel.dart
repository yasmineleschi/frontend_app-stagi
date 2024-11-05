import 'dart:typed_data'; // Import for Uint8List
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublicationViewModel extends ChangeNotifier {
  final String backendUrl = 'http://localhost:5001/api/publications'; // Adjust the URL as needed
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

  Future<void> createPublication(String token, String title, String content, Uint8List? imageBytes) async {
    try {
      isLoading = true;
      notifyListeners();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(backendUrl),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Add the title and content
      request.fields['title'] = title;
      request.fields['content'] = content;

      // Check if image is provided and add it
      if (imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image', // Change this to the key expected by your backend
          imageBytes,
          filename: 'image.jpg', // You can change the filename or get it dynamically
        ));
      }

      final response = await request.send();

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
