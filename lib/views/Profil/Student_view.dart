import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/student_viewmodel.dart';
import 'package:frontend_app_stagi/views/Profil/Sections/education_section.dart';
import 'package:frontend_app_stagi/views/Profil/Sections/experience_section.dart';
import 'package:frontend_app_stagi/views/Profil/Sections/profile_header.dart';
import 'package:frontend_app_stagi/views/Profil/Sections/skills_section.dart';
import 'package:frontend_app_stagi/views/Profil/Sections/about_section.dart';
import 'package:provider/provider.dart';

class StudentProfileView extends StatelessWidget {
  final String userId;

  const StudentProfileView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentProfileViewModel()..getStudentProfile(userId),
      child: Scaffold(
        body: Container(
          color: const Color(0xFFF5F2F2),
          child: Consumer<StudentProfileViewModel>(
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

              return Column(
                children: [
                  ProfileHeader(profile: profile,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AboutSection(
                            profile: profile,
                            onBioUpdated: (bio) {
                              viewModel.updateBio(profile.userId!, bio);
                            },
                          ),
                          const SizedBox(height: 10),
                          SkillsSection(
                            skills: profile.skills,
                            onSkillUpdated: (updatedSkill) {
                              viewModel.updateSkill(profile.userId!, updatedSkill);
                            },
                          ),
                          const SizedBox(height: 10),
                          EducationSection(
                            educationList: profile.education,
                            onEducationUpdated: (updatedEducation) {
                              viewModel.updateEducation(profile.userId!, updatedEducation);
                            },
                          ),
                          const SizedBox(height: 10),
                          ExperienceSection(
                            experiences: profile.experience,
                            onExperienceUpdated: (updatedExperience) {
                              viewModel.updateExperience(profile.userId!, updatedExperience);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StudentProfileView(
      userId: '6716377dffbb52f37658d2eb',
    ),
  ));
}
