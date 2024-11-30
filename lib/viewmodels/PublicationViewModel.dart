import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http_parser/http_parser.dart';

class PublicationViewModel extends ChangeNotifier {
  final String backendUrl = 'http://10.0.2.2:5001/api/publications';
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



  Future<void> createPublication(
      String token,
      String title,
      String content,
      Uint8List? image, // Image in bytes (for image uploads)
      Uint8List? pdf,   // PDF in bytes (for PDF uploads)
      ) async {
    final uri = Uri.parse('http://10.0.2.2:5001/api/publications');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = title
      ..fields['content'] = content;

    // Add image to the request (if available)
    if (image != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image', // The field name expected by the backend
          image,   // Image byte data
          filename: 'image.png', // Set a default filename for the image
          contentType: MediaType('image', 'png'), // Correct MIME type for image
        ),
      );
    }

    // Add PDF to the request (if available)
    if (pdf != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'pdf', // The field name expected by the backend
          pdf,   // PDF byte data
          filename: 'file.pdf', // Set a default filename for the PDF
          contentType: MediaType('application', 'pdf'), // Correct MIME type for PDF
        ),
      );
    }

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        print('Publication created successfully');
        // Optionally, you can fetch the publications again after successful creation
      } else {
        // Log the full response for debugging purposes
        final responseBody = await response.stream.bytesToString();
        print('Failed to create publication. Status code: ${response.statusCode}');
        print('Response body: $responseBody');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }





  Future<void> likePublication(String token, String publicationId) async {
    try {
      final response = await http.patch(
        Uri.parse('$backendUrl/$publicationId/like'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        await fetchPublications(token); // Refresh publications to update like count
      } else {
        errorMessage = 'Failed to like publication';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    }
    notifyListeners();
  }

  Future<void> unlikePublication(String token, String publicationId) async {
    try {
      final response = await http.patch(
        Uri.parse('$backendUrl/$publicationId/unlike'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        await fetchPublications(token); // Refresh publications to update like count
      } else {
        errorMessage = 'Failed to unlike publication';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    }
    notifyListeners();
  }

  Future<void> toggleLike(String token, String publicationId, bool hasLiked) async {
    if (hasLiked) {
      await unlikePublication(token, publicationId);
    } else {
      await likePublication(token, publicationId);
    }
  }
}
