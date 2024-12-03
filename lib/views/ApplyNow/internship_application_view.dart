import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/internship_application.dart';
import 'package:frontend_app_stagi/viewmodels/internship_application_viewmodel.dart';
import 'package:frontend_app_stagi/widgets/file_viewer.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class InternshipApplicationsPage extends StatefulWidget {
  final String companyId;

  const InternshipApplicationsPage({Key? key, required this.companyId})
      : super(key: key);

  @override
  State<InternshipApplicationsPage> createState() =>
      _InternshipApplicationsPageState();
}

class _InternshipApplicationsPageState extends State<InternshipApplicationsPage> {
  String selectedFilter = "All";
  void _openAttachment(String filePath) async {
    final url = 'http://10.0.2.2:5001/api/attachment/view/$filePath';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$filePath');

        await tempFile.writeAsBytes(response.bodyBytes);

        if (filePath.endsWith('.pdf')) {

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InternshipViewModel>(context, listen: false)
          .fetchApplications(widget.companyId);
    });
  }


  void _showInterviewDatePicker(InternshipApplication application) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      await Provider.of<InternshipViewModel>(context, listen: false)
          .updateApplicationStatus(
        application.id ?? '',
        "Accepted",
        interviewDate: selectedDate,
      );
    }
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = "Pending";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedFilter == "Pending"
                            ? Colors.white
                            : Colors.grey[200],
                      ),
                      child: Text("Pending", style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = "Accepted";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedFilter == "Accepted"
                            ? Colors.green
                            : Colors.grey[200],
                      ),
                      child: Text("Accepted", style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = "Rejected";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedFilter == "Rejected"
                            ? Colors.red
                            : Colors.grey[200],
                      ),
                      child: Text("Rejected", style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Consumer<InternshipViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.isLoading) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final filteredApplications = viewModel.applications
                          .where((application) =>
                      selectedFilter == "All" ||
                          application.status == selectedFilter)
                          .toList();

                      filteredApplications.sort((a, b) {
                        const statusPriority = {
                          "Pending": 0,
                          "Accepted": 1,
                          "Rejected": 2,
                        };
                        return statusPriority[a.status]!
                            .compareTo(statusPriority[b.status] ?? 3) ??
                            0;
                      });

                      if (filteredApplications.isEmpty) {
                        return Center(
                          child: Text("No applications found."),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredApplications.length,
                        itemBuilder: (context, index) {
                          final application = filteredApplications[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 5.0,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.business_center, color: Colors.blueGrey, size: 24),
                                            const SizedBox(width: 8),
                                            Text(
                                              "stage: ",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text(
                                              application.internshipTitle,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12.0),
                                        Row(
                                          children: [
                                            Icon(Icons.message_outlined, color: Colors.blueGrey, size: 24),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                application.message,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12.0),
                                        Row(
                                          children: [
                                            Icon(Icons.attach_file, color: Colors.blueGrey, size: 24),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                                onTap: () => _openAttachment(application.attachmentId ?? ''),
                                              child: Text(
                                                "cv: ${application.attachmentId}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],

                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                        const SizedBox(height: 12.0),
                                        Row(
                                          children: [
                                            Icon(
                                              application.status.toLowerCase() == 'accepted'
                                                  ? Icons.check_circle_outline
                                                  : application.status.toLowerCase() == 'rejected'
                                                  ? Icons.cancel_outlined
                                                  : Icons.pending_outlined,
                                              color: application.status.toLowerCase() == 'accepted'
                                                  ? Colors.green
                                                  : application.status.toLowerCase() == 'rejected'
                                                  ? Colors.red
                                                  : Colors.grey,
                                              size: 24,
                                            ),
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
                                        const SizedBox(height: 12.0),
                                        Divider(color: Colors.grey[200],),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.access_alarm_outlined, color: Colors.blueGrey, size: 24),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Applied at: ${formatDate(application.appliedAt)}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == "Accepted") {
                                          _showInterviewDatePicker(application);
                                        } else {
                                          viewModel.updateApplicationStatus(
                                            application.id ?? '',
                                            value,
                                          );
                                        }
                                      },
                                      iconColor: Colors.orangeAccent,
                                      color: Colors.white,
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: "Accepted",
                                          child: Row(
                                            children: [
                                              Icon(Icons.check_circle, color: Colors.green, size: 20),
                                              const SizedBox(width: 8),
                                              Text("Accept"),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: "Rejected",
                                          child: Row(
                                            children: [
                                              Icon(Icons.cancel, color: Colors.red, size: 20),
                                              const SizedBox(width: 8),
                                              Text("Reject"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        },
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => InternshipViewModel(),
      child: MaterialApp(
        home: InternshipApplicationsPage(companyId: '673a4bc6227d449dda04c2dc'),
      ),
    ),
  );
}
