import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/internship_application_viewmodel.dart';
import 'package:provider/provider.dart';

class StudentApplicationsPage extends StatefulWidget {
  final String studentId;

  const StudentApplicationsPage({Key? key, required this.studentId})
      : super(key: key);

  @override
  State<StudentApplicationsPage> createState() =>
      _StudentApplicationsPageState();
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
          child: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Confirm Internship",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto Slab",
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF1B3B6D),
            elevation: 4,
            centerTitle: true,
          ),
        ),
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
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.business_center,
                                color: Colors.blueGrey ,size: 25,),
                            const SizedBox(width: 8.0),
                            Text(
                              "stage : ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              application.internshipTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14.0),
                        Row(

                          children: [
                            const Icon(Icons.message, color: Colors.blueGrey),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                "Message: ${application.message}",
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14.0),
                        Row(
                          children: [
                            const Icon(Icons.info, color: Colors.blueGrey),
                            const SizedBox(width: 8.0),
                            Text(
                              "Status: ${application.status}",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: application.status.toLowerCase() == 'accepted'
                                    ? Colors.green
                                    : application.status.toLowerCase() == 'rejected'
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                            ],
                        ),
                        const SizedBox(height: 14.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          color: Colors.blueGrey),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        "Applied At :",
                                        style: const TextStyle(fontSize: 15.0,color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    formatDate(application.appliedAt),
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                            if (application.interviewDate != null)
                              const SizedBox(height: 12.0),
                            if (application.interviewDate != null)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.video_call,
                                            color: Colors.green),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          "Interview: ",
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      formatDate(application.interviewDate!),
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),

                          ],
                        ),
                      ],
                    ),
                  ),
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
