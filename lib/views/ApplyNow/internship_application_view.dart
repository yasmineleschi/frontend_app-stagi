import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/internship_application_viewmodel.dart';
import 'package:provider/provider.dart';


class InternshipApplicationsPage extends StatefulWidget {
  final String companyId;

  const InternshipApplicationsPage({Key? key, required this.companyId}) : super(key: key);

  @override
  State<InternshipApplicationsPage> createState() => _InternshipApplicationsPageState();
}

class _InternshipApplicationsPageState extends State<InternshipApplicationsPage> {
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
      appBar: AppBar(title: Text("Internship Applications")),
      body: Consumer<InternshipViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (viewModel.applications.isEmpty) {
            return Center(child: Text("No applications found."));
          }
          return ListView.builder(
            itemCount: viewModel.applications.length,
            itemBuilder: (context, index) {
              final application = viewModel.applications[index];
              return ListTile(
                title: Text(application.message),
                subtitle: Text("attchement: ${application.attachmentId}"),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    viewModel.updateApplicationStatus(application.id ?? '', value);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: "Accepted", child: Text("Accept")),
                    PopupMenuItem(value: "Rejected", child: Text("Reject")),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<InternshipViewModel>(context, listen: false)
              .fetchApplications(widget.companyId);
        },
        child: Icon(Icons.refresh),
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