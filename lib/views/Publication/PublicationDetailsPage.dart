import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/views/Comments/CommentsPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class PublicationDetailsPage extends StatefulWidget {
  final String publicationId;
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

  Future<void> fetchPublicationDetails() async {
    try {
      final response = await http.get(

        Uri.parse('https://backend-app-stagi.vercel.app/api/publications/${widget.publicationId}'),

        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final publication = json.decode(response.body);
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

  Future<void> openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showImagePopup(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publication Details'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img_4.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title Section
              Center(
                child: Text(
                  publicationDetails?['title'] ?? 'No Title',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white),

              // Image Section with Popup
              if (publicationDetails?['image'] != null)
                GestureDetector(
                  onTap: () => showImagePopup(publicationDetails!['image']),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      publicationDetails!['image'],
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
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
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // PDF Link Section
              if (publicationDetails?['pdf'] != null)
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.redAccent,
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    title: const Text(
                      'View Attached PDF',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onTap: () => openURL(publicationDetails!['pdf']),
                  ),
                ),
              const SizedBox(height: 16),

              // Comments Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
      ),
    );
  }
}
