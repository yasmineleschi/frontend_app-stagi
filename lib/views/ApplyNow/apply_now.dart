import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/attachment_viewmodel.dart';
import 'package:frontend_app_stagi/viewmodels/internship_application_viewmodel.dart';  // Correct import
import 'package:provider/provider.dart';

class ApplyForInternshipPage extends StatefulWidget {
  final String internshipId;
  final String studentId;

  const ApplyForInternshipPage({
    Key? key,
    required this.internshipId,
    required this.studentId,
  }) : super(key: key);

  @override
  State<ApplyForInternshipPage> createState() => _ApplyForInternshipPageState();
}

class _ApplyForInternshipPageState extends State<ApplyForInternshipPage> {
  final _formKey = GlobalKey<FormState>();
  String? _message;
  String? _selectedAttachment;

  @override
  void initState() {
    super.initState();

    Provider.of<AttachmentViewModel>(context, listen: false)
        .fetchAttachments(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Apply for Internship")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer2<InternshipViewModel, AttachmentViewModel>(
          builder: (context, internshipViewModel, attachmentViewModel, child) {
            if (attachmentViewModel.isUploading) {
              return Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Message"),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Message is required.";
                      }
                      return null;
                    },
                    onSaved: (value) => _message = value,
                  ),
                  SizedBox(height: 16),

                    DropdownButton<String>(
                      value: _selectedAttachment,
                      hint: Text("Select an attachment"),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedAttachment = newValue;
                        });
                      },
                      items: attachmentViewModel.attachments
                          .map<DropdownMenuItem<String>>((attachment) {
                        return DropdownMenuItem<String>(
                          value: attachment.id,
                          child: Text(attachment.fileName ?? 'Unknown Attachment'),
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();


                        await internshipViewModel.applyForInternship(
                          internshipId: widget.internshipId,
                          studentId: widget.studentId,
                          message: _message!,
                          attachmentId: _selectedAttachment,
                        );

                        print('Submitting application...');
                        print('Internship ID: ${widget.internshipId}');
                        print('Student ID: ${widget.studentId}');
                        print('Selected Attachment: $_selectedAttachment');

                        if (internshipViewModel.errorMessage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Application submitted!")),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(internshipViewModel.errorMessage!)),
                          );
                        }
                      }
                    },
                    child: Text("Submit Application"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
