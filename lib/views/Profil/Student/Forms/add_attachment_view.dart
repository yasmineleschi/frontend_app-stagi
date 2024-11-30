import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/attachment_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class AddAttachmentView extends StatefulWidget {
  final String studentId;

  const AddAttachmentView({Key? key, required this.studentId}) : super(key: key);

  @override
  _AddAttachmentViewState createState() => _AddAttachmentViewState();
}

class _AddAttachmentViewState extends State<AddAttachmentView> {
  File? _selectedFile;
  bool _isUploading = false; // Variable to control the loading state

  // Function to pick the PDF file
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      if (file.path != null) {
        setState(() {
          _selectedFile = File(file.path!); // Save the file path
        });
      }
    }
  }


  void _uploadFile() async {
    if (_selectedFile != null) {
      setState(() {
        _isUploading = true; // Show the loading indicator
      });

      try {
        final viewModel = Provider.of<AttachmentViewModel>(context, listen: false);

        // Log the file before uploading
        print("Uploading file: ${_selectedFile!.path}");

        await viewModel.uploadAttachment(widget.studentId, _selectedFile!);
        print("Upload completed");

        setState(() {
          _isUploading = false; // Hide the loading indicator after upload
        });

      } catch (e) {
        setState(() {
          _isUploading = false; // Hide the loading indicator on error
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a file first")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AttachmentViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Add Attachment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display selected file path
            if (_selectedFile != null)
              Text("Selected File: ${_selectedFile!.path.split('/').last}"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text("Pick PDF File"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadFile, // Disable button while uploading
              child: _isUploading
                  ? CircularProgressIndicator()
                  : Text("Upload File"),
            ),
            SizedBox(height: 16),
            Text("Uploaded Attachments:"),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.attachments.length,
                itemBuilder: (context, index) {
                  final attachment = viewModel.attachments[index];
                  return ListTile(
                    title: Text(attachment.fileName),
                    subtitle: Text(attachment.fileType),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
