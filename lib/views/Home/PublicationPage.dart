import 'dart:typed_data'; // Import this for Uint8List
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/PublicationViewModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Check for web platform

class PublicationPage extends StatefulWidget {
  final String token;

  const PublicationPage({Key? key, required this.token}) : super(key: key);

  @override
  _PublicationPageState createState() => _PublicationPageState();
}

class _PublicationPageState extends State<PublicationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Uint8List? _selectedImage; // Change to Uint8List

  final ImagePicker _picker = ImagePicker();

  // Method to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Read the file as bytes
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = bytes; // Store the bytes
      });
    }
  }

  void _submitPublication() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      Provider.of<PublicationViewModel>(context, listen: false)
          .createPublication(widget.token, title, content, _selectedImage) // Pass bytes instead of File
          .then((_) {
        Navigator.pop(context); // Go back to the home page
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Publication")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 8),
            // Image Picker Button
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text("Pick Image"),
                ),
                SizedBox(width: 10),
                _selectedImage != null
                    ? Image.memory(_selectedImage!, width: 50, height: 50) // Use Image.memory
                    : Text("No image selected"),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitPublication,
              child: Text("Publish"),
            ),
          ],
        ),
      ),
    );
  }
}