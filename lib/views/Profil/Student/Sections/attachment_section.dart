import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/attachment_model.dart';
import 'package:frontend_app_stagi/services/attachment_service.dart';
import 'package:frontend_app_stagi/viewmodels/attachment_viewmodel.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Forms/add_attachment_view.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetViewProfile/widget_sections.dart';
import 'package:provider/provider.dart';

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

  Future<void> _uploadAttachment(File file) async {
    setState(() {
      _isUploading = true;
    });

    try {
      final attachment = await _attachmentService.uploadAttachment(widget.studentId, file);
      if (attachment != null) {
        setState(() {
          _attachments.add(attachment);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to upload attachment: $e';
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
                );// Close the dialog

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
                    trailing: IconButton(
                      icon: Icon(Icons.download),
                      onPressed: () {
                        // Implement your file download logic here
                      },
                    ),
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
