import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/company_viewmodel.dart';
import 'package:frontend_app_stagi/views/Profil/Company/Sections/company_profile_header.dart';
import 'package:frontend_app_stagi/views/Profil/Company/Sections/description_section.dart';
import 'package:frontend_app_stagi/views/Profil/Company/Sections/internship_section.dart';
import 'package:provider/provider.dart';

class CompanyProfileView extends StatelessWidget {
  final String userId;

  const CompanyProfileView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompanyProfileViewModel()..getCompanyProfile(userId),
      child: DefaultTabController(
        length: 2,
        child: Consumer<CompanyProfileViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (viewModel.errorMessage.isNotEmpty) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF1B3B6D),
                  title: const Text('Company Profile'),
                ),
                body: Center(child: Text(viewModel.errorMessage)),
              );
            }

            final profile = viewModel.company;

            if (profile == null) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF1B3B6D),
                  title: const Text('Company Profile'),
                ),
                body: const Center(child: Text('No profile data available.')),
              );
            }

            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(150.0),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xFFF5F2F2),
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: CompanyProfileHeader(Companyprofile: profile),
                  ),
                ),
              ),
              body: Container(
                color: const Color(0xFFF5F2F2),
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(
                          text: 'About Us',
                          icon: Icon(Icons.account_box_outlined),
                        ),
                        Tab(
                          text: 'Internships',
                          icon: Icon(Icons.work_outline_outlined),
                        ),
                      ],
                      labelColor: Colors.deepOrangeAccent,
                      indicatorColor: Colors.orangeAccent,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: DescriptionSection(companyProfile: profile),
                          ),
                          SingleChildScrollView(
                            child: InternshipSection(
                              internships: profile.internships,
                              onInternshipUpdated: (updatedInternship) {
                                viewModel.updateInternship(profile.userId!, updatedInternship);
                              },
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
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CompanyProfileView(
      userId: '672cca0757f81eaffe7c119f',
    ),
  ));
}
