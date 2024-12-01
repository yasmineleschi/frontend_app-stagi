import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/internship_application_viewmodel.dart';
import 'package:provider/provider.dart';

class InternshipApplicationsPage extends StatefulWidget {
  final String companyId;

  const InternshipApplicationsPage({Key? key, required this.companyId})
      : super(key: key);

  @override
  State<InternshipApplicationsPage> createState() =>
      _InternshipApplicationsPageState();
}

class _InternshipApplicationsPageState
    extends State<InternshipApplicationsPage> {
  String selectedFilter = "All"; // Filtre par défaut

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InternshipViewModel>(context, listen: false)
          .fetchApplications(widget.companyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Confirm Internship",
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
                      child: Text("Pending" , style: TextStyle(color: Colors.black),),
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
                      child: Text("Accepted",style: TextStyle(color: Colors.black),),
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
                      child: Text("Rejected",style: TextStyle(color: Colors.black),),
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
                        return statusPriority[a.status]
                            ?.compareTo(statusPriority[b.status] ?? 3) ??
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
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          application.message,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          "Attachment: ${application.attachmentId}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          "Status: ${application.status}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          "Applied at: ${application.appliedAt.toString()}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: PopupMenuButton<String>(
                                      onSelected: (value) {
                                        viewModel.updateApplicationStatus(
                                            application.id ?? '', value);
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: "Accepted",
                                            child: Text("Accept")),
                                        PopupMenuItem(
                                            value: "Rejected",
                                            child: Text("Reject")),
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
