import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/internship_application_viewmodel.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Apply for Internship")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<InternshipViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
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
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        await viewModel.applyForInternship(
                          internshipId: widget.internshipId,
                          studentId: widget.studentId,
                          message: _message!,
                        );

                        if (viewModel.errorMessage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Application submitted!")),
                          );
                          Navigator.pop(context); // Go back to previous page
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(viewModel.errorMessage!)),
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
