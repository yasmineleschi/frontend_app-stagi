import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublicationViewModel extends ChangeNotifier {
  final String backendUrl = 'http://localhost:5001/api/publications';
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

      final request = http.MultipartRequest('POST', Uri.parse(backendUrl));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = title;
      request.fields['content'] = content;

      if (imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: 'image.jpg'));
      }

      final response = await request.send();
      if (response.statusCode == 201) {
        await fetchPublications(token); // Refresh publications
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
