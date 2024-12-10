import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/widgets/file_viewer.dart';
import 'package:frontend_app_stagi/models/attachment_model.dart';
import 'package:frontend_app_stagi/services/attachment_service.dart';
import 'package:frontend_app_stagi/viewmodels/attachment_viewmodel.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Forms/add_attachment_view.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetViewProfile/widget_sections.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'as http;
class AttachmentsSection extends StatefulWidget {
  final String studentId;

  const AttachmentsSection({Key? key, required this.studentId}) : super(key: key);

  @override
  _AttachmentsSectionState createState() => _AttachmentsSectionState();
}

class _AttachmentsSectionState extends State<AttachmentsSection> {
  final AttachmentService _attachmentService = AttachmentService();
  bool _isUploading = false;
  List<AttachmentModel> _attachments = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAttachments();
  }
  void _openAttachment(String filePath) async {
    final url = 'http://10.0.2.2:5001/api/attachment/view/$filePath';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$filePath');

        await tempFile.writeAsBytes(response.bodyBytes);

        if (filePath.endsWith('.pdf')) {
          // Navigate to a PDF viewer page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerPage(filePath: tempFile.path),
            ),
          );
        } else {
          OpenFile.open(tempFile.path);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Échec de l'ouverture du fichier.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  Future<void> _fetchAttachments() async {
    setState(() {
      _isUploading = true;
      _errorMessage = '';
    });

    try {
      List<AttachmentModel> attachments = await _attachmentService.getAttachments(widget.studentId);
      setState(() {
        _attachments = attachments;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load attachments: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showAddAttachmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Attachment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You will be redirected to the upload page.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => AttachmentViewModel(),
                      child: AddAttachmentView(studentId: widget.studentId),
                    ),
                  ),
                );
              },
              child: Text('Go to Upload Page'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionCard(
            title: 'Attachments',
            content: _isUploading
                ? CircularProgressIndicator()
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_attachments.isEmpty)
                  Text('No attachments available.'),
                ..._attachments.map((attachment) {
                  return ListTile(
                    title: Text(attachment.fileName),
                    subtitle: Text(attachment.fileType),
                    trailing: Icon(Icons.file_open),
                    onTap: () => _openAttachment(attachment.fileName),
                  );
                }).toList(),
              ],
            ),
            icon: Icons.attach_file,
            hasAddIcon: () => _showAddAttachmentDialog(context),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
