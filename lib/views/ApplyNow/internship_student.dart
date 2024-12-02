import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/internship_application_viewmodel.dart';
import 'package:provider/provider.dart';

class StudentApplicationsPage extends StatefulWidget {
  final String studentId;

  const StudentApplicationsPage({Key? key, required this.studentId}) : super(key: key);

  @override
  State<StudentApplicationsPage> createState() => _StudentApplicationsPageState();
}

class _StudentApplicationsPageState extends State<StudentApplicationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InternshipViewModel>(context, listen: false)
          .fetchApplicationsForStudent(widget.studentId)
          .catchError((e) {
        debugPrint("Error in fetching applications: $e");
      });
    });
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Applications"),
        centerTitle: true,
      ),
      body: Consumer<InternshipViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${viewModel.errorMessage}"),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.fetchApplicationsForStudent(widget.studentId);
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (viewModel.applications.isEmpty) {
            return const Center(child: Text('No applications found.'));
          }

          return ListView.builder(
            itemCount: viewModel.applications.length,
            itemBuilder: (context, index) {
              final application = viewModel.applications[index];
              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(
                    "Internship ID: ${application.internshipId}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Message: ${application.message}"),
                      Text("Status: ${application.status}"),
                      Text("Applied At: ${formatDate(application.appliedAt)}"),
                    ],
                  ),
                  trailing: application.interviewDate != null
                      ? Text(
                    "Interview: ${formatDate(application.interviewDate!)}",
                    style: const TextStyle(color: Colors.green),
                  )
                      : const Text("No interview scheduled"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => InternshipViewModel(),
      child: MaterialApp(
        home: StudentApplicationsPage(studentId: '672b22b6283d37063db38e35'),
      ),
    ),
  );
}
