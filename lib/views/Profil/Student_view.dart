import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/student_viewmodel.dart';
import 'package:frontend_app_stagi/widgets/WidgetViewProfile/education_section.dart';
import 'package:frontend_app_stagi/widgets/WidgetViewProfile/experience_section.dart';
import 'package:frontend_app_stagi/widgets/WidgetViewProfile/profile_header.dart';
import 'package:frontend_app_stagi/widgets/WidgetViewProfile/skills_section.dart';
import 'package:provider/provider.dart';


class StudentProfileView extends StatelessWidget {
  final String userId;

  StudentProfileView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentProfileViewModel()..getStudentProfile(userId),
      child: Scaffold(

        body: Consumer<StudentProfileViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage.isNotEmpty) {
              return Center(child: Text(viewModel.errorMessage));
            }

            final profile = viewModel.studentProfile;

            if (profile == null) {
              return const Center(child: Text('No profile data available.'));
            }

            return Stack(
              children: [

              Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background_profile.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

             SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 170),
                    ProfileHeader(profile: profile),
                    const SizedBox(height: 10,),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 10,),
                    SkillsSection(skills: profile.skills),
                    const SizedBox(height: 10,),
                    EducationSection(education: profile.education),
                    const SizedBox(height: 10,),
                    ExperienceSection(experiences: profile.experience),
                  ],
                ),
              ),
            ),
              ],
            );
          },
        ),
      ),
    );
  }
}






void main() {
  runApp(MaterialApp(
    home: StudentProfileView(userId: '6707a1dbe577fcca2132b883',),
  ));
}
