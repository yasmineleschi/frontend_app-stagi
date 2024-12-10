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
    } else {
      // User canceled or no file picked
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file selected")),
      );
    }
  }

  // Function to upload the file
  void _uploadFile() async {
    if (_selectedFile != null) {
      setState(() {
        _isUploading = true; // Show the loading indicator
      });

      try {
        final viewModel = Provider.of<AttachmentViewModel>(context, listen: false);

        // Log the file before uploading
        print("Uploading file: ${_selectedFile!.path}");

        // Upload the selected file
        await viewModel.uploadAttachment(widget.studentId, _selectedFile!);
        print("Upload completed");

        // After upload, update UI state
        setState(() {
          _isUploading = false; // Hide the loading indicator
        });

        // Optionally refresh the attachments list after upload (if necessary)
        viewModel.fetchAttachments(widget.studentId); // Assuming this function exists

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
        const SnackBar(content: Text("Please select a file first")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AttachmentViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Attachment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display selected file path
            if (_selectedFile != null)
              Text("Selected File: ${_selectedFile!.path.split('/').last}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text("Pick PDF File"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadFile, // Disable button while uploading
              child: _isUploading
                  ? const CircularProgressIndicator()  // Display loading indicator
                  : const Text("Upload File"),
            ),
            const SizedBox(height: 16),
            const Text("Uploaded Attachments:"),
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
