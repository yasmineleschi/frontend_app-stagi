import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/attachment_viewmodel.dart';
import 'package:frontend_app_stagi/viewmodels/internship_application_viewmodel.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/ConfirmationBottomSheet.dart';
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
    return WillPopScope(
      onWillPop: () async {
        _showConfirmationBottomSheet(context);
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Apply for Internship",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto Slab",
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xFF1B3B6D),
            elevation: 0,
            centerTitle: true,
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B3B6D), Color(0xFF79A6D2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer2<InternshipViewModel, AttachmentViewModel>(
                builder: (context, internshipViewModel, attachmentViewModel, child) {
                  if (attachmentViewModel.isUploading) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Personalize your application",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Write a short message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Message is required.";
                            }
                            return null;
                          },
                          onSaved: (value) => _message = value,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Select an attachment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedAttachment,
                            hint: Text(
                              "Choose your attachment",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            isExpanded: true,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedAttachment = newValue;
                              });
                            },
                            items: attachmentViewModel.attachments
                                .map<DropdownMenuItem<String>>((attachment) {
                              return DropdownMenuItem<String>(
                                value: attachment.id,
                                child: Text(
                                  attachment.fileName ?? 'Unknown Attachment',
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF79A6D2),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState?.save();
                                await internshipViewModel.applyForInternship(
                                  internshipId: widget.internshipId,
                                  studentId: widget.studentId,
                                  message: _message!,
                                  attachmentId: _selectedAttachment,
                                );

                                if (internshipViewModel.errorMessage == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Application submitted!"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(internshipViewModel.errorMessage!),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            icon: Icon(Icons.send, color: Colors.white),
                            label: Text(
                              "Submit Application",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationBottomSheet(
          title: 'Discard Application?',
          message: 'Are you sure you want to discard your internship application?',
          onContinue: () {
          },
          onUndo: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

}
