import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/views/Home/CommentsPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublicationDetailsPage extends StatefulWidget {
  final String publicationId; // Pass publication ID to this page
  final String token;

  const PublicationDetailsPage({Key? key, required this.publicationId, required this.token}) : super(key: key);

  @override
  State<PublicationDetailsPage> createState() => _PublicationDetailsPageState();
}

class _PublicationDetailsPageState extends State<PublicationDetailsPage> {
  Map<String, dynamic>? publicationDetails;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPublicationDetails();
  }

  // Fetch publication details from the backend
  Future<void> fetchPublicationDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5001/api/publications/${widget.publicationId}'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final publication = json.decode(response.body);

        // Debug to ensure 'image' is received
        print(publication['image']); // Check if image URL is present

        setState(() {
          publicationDetails = publication;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load publication details';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching data
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Display error message if any
    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publication Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Text(
              publicationDetails?['title'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Image Section (if available)
            if (publicationDetails?['image'] != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    publicationDetails!['image'], // Use the URL directly without prepending 'http://localhost:5001/'
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Content Section
            Text(
              publicationDetails?['content'] ?? 'No Content',
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            // Comment Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentsPage(
                      publicationId: widget.publicationId,
                      token: widget.token,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.comment, color: Colors.white),
              label: const Text(
                'View/Add Comments',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
