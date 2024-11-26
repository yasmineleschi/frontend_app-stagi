import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend_app_stagi/viewmodels/PublicationViewModel.dart';
import 'package:provider/provider.dart';

// Custom TextField widget for consistent styling
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final String hintText;
  final bool isReadOnly;
  final Function()? onTap;
  final int maxLines;

  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.hintText,
    this.isReadOnly = false,
    this.onTap,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
    );
  }
}

class PublicationPage extends StatefulWidget {
  final String token;

  const PublicationPage({Key? key, required this.token}) : super(key: key);

  @override
  _PublicationPageState createState() => _PublicationPageState();
}

class _PublicationPageState extends State<PublicationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Uint8List? _selectedImage;
  Uint8List? _selectedPdf;

  // Method to pick an image from gallery
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      if (file.bytes != null) {
        setState(() {
          _selectedImage = file.bytes;
        });
      }
    }
  }

  // Method to pick a PDF file
  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      if (file.bytes != null) {
        setState(() {
          _selectedPdf = file.bytes;
        });
      }
    }
  }

  // Submit publication
  void _submitPublication() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      print("Error: Title or content is empty");
      return;
    }

    Provider.of<PublicationViewModel>(context, listen: false)
        .createPublication(widget.token, title, content, _selectedImage, _selectedPdf)
        .then((_) {
      print("Publication submitted successfully.");
      Navigator.pop(context); // Go back to the previous screen
    }).catchError((e) {
      print("Error during publication creation: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Publication"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity, // Ensures the width fills the screen
        height: double.infinity, // Ensures the height fills the screen
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img_4.png"), // Background image
            fit: BoxFit.fill, // Make the image fill the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                CustomTextField(
                  controller: _titleController,
                  labelText: 'Title',
                  icon: Icons.title,
                  hintText: 'Enter the title of the publication',
                ),
                const SizedBox(height: 20),

                // Content field
                CustomTextField(
                  controller: _contentController,
                  labelText: 'Content',
                  icon: Icons.description,
                  hintText: 'Enter the content of the publication',
                  maxLines: 6,
                ),
                const SizedBox(height: 20),

                // Image picker
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                      ),
                      child: Text("Pick Image"),
                    ),
                    SizedBox(width: 10),
                    _selectedImage != null
                        ? Image.memory(_selectedImage!, width: 50, height: 50)
                        : Text("No image selected"),
                  ],
                ),
                const SizedBox(height: 20),

                // PDF picker
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickPdf,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Button color
                      ),
                      child: Text("Pick PDF"),
                    ),
                    SizedBox(width: 10),
                    _selectedPdf != null
                        ? Text("PDF picked")
                        : Text("No PDF selected"),
                  ],
                ),
                const SizedBox(height: 20),

                // Publish button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitPublication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Button color
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Publish", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
