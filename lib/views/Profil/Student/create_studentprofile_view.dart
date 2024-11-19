import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/viewmodels/student_viewmodel.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Forms/basic_info_form.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Forms/education_form.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Forms/experience_form.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Forms/skills_form.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Student_view.dart';
import 'package:provider/provider.dart';

class ProfileStepper extends StatefulWidget {
  final String userId;

  ProfileStepper({required this.userId});

  @override
  _ProfileStepperState createState() => _ProfileStepperState();
}

class _ProfileStepperState extends State<ProfileStepper> {
  int _currentStep = 0;
  File? _profileImage;


  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController specialityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final TextEditingController degreeController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController specialitController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final TextEditingController skillController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();

  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController responsibilityController = TextEditingController();

  List<Skill> skills = [];
  List<Experience> experiences = [];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StudentProfileViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img_4.png'),
                fit: BoxFit.cover,

              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 80),
              const Center(
                child: Text(
                  "Create My Profile",
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: 'Roboto Slab',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(

                    primaryColor:  Color(0xFF3A6D8C),

                    colorScheme: ColorScheme.light(primary:  Color(0xFF3A6D8C)),

                    dividerColor:  Color(0xFF3A6D8C),
                  ),
                  child: Stepper(
                    currentStep: _currentStep,
                    onStepContinue: () async {
                      if (_currentStep < 3) {
                        if (_currentStep == 0) {
                          if (BasicInfoForm.isValid(
                              context,
                              firstNameController: firstNameController,
                              lastNameController: lastNameController,
                              phoneController: phoneController,
                              specialityController: specialityController,
                              bioController: bioController,
                              locationController: locationController)) {
                            setState(() => _currentStep++);
                          }
                        } else if (_currentStep < 3) {
                          setState(() => _currentStep++);
                        }
                      }else {

                        bool shouldProceed = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmation',style: TextStyle(
                                fontSize: 34,
                                fontFamily: 'Roboto Slab',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF091057),
                              ),),
                              content: const Text('Are you sure you want to continue and create your profile?',style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto Slab',
                                fontWeight: FontWeight.w200,
                                color: Colors.black,
                              ),),
                              actions: [
                                TextButton(

                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },

                                  child: const Text('No',style: TextStyle(
                                    fontFamily: 'Roboto Slab',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),),
                                ),
                                ElevatedButton(

                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Yes',style: TextStyle(
                                    fontFamily: 'Roboto Slab',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldProceed) {
                          StudentProfile profile = StudentProfile(
                            userId: widget.userId,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            phone: phoneController.text,
                            bio: bioController.text,
                            location: locationController.text,
                            specialite: specialityController.text,
                            profileImage: _profileImage?.path,
                            education: [
                              Education(
                                degree: degreeController.text,
                                institution: institutionController.text,
                                specialite: specialitController.text,
                                startDate: DateTime.parse(startDateController.text),
                                endDate: DateTime.parse(endDateController.text),
                              ),
                            ],
                            skills: skills,
                            experience: experiences,
                          );

                          bool success = await viewModel.createStudentProfile(profile, widget.userId);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Success',
                                  message: 'Profile created successfully',
                                  contentType: ContentType.success,
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentProfileView(userId: widget.userId),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(viewModel.errorMessage)),
                            );
                          }
                        }
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) setState(() => _currentStep--);
                    },
                    steps: [
                      Step(
                        title: const Text('Basic Info',
                            style: TextStyle(
                              fontSize: 20,
                                color: Color(0xFF091057),
                              fontFamily: 'Roboto Slab',
                            ), ),
                        content: BasicInfoForm(
                          firstNameController: firstNameController,
                          lastNameController: lastNameController,
                          phoneController: phoneController,
                          bioController: bioController,
                          specialityController: specialityController,
                          locationController: locationController,
                        ),
                        state: _currentStep > 0 ? StepState.complete : StepState
                            .indexed,
                        isActive: _currentStep >= 0,
                      ),
                      Step(
                        title: const Text('Education',
                            style: TextStyle(
                              fontSize: 20,
                              color:Color(0xFF091057),
                              fontFamily: 'Roboto Slab',)),
                        content: EducationForm(
                          degreeController: degreeController,
                          institutionController: institutionController,
                          specialitController: specialitController,
                          startDateController: startDateController,
                          endDateController: endDateController,
                        ),
                        state: _currentStep > 1 ? StepState.complete : StepState
                            .indexed,
                        isActive: _currentStep >= 1,
                      ),
                      Step(
                        title: const Text('Skills',
                            style: TextStyle( fontSize: 20,
                              color: Color(0xFF091057),
                              fontFamily: 'Roboto Slab',)),
                        content: SkillsForm(
                          skillController: skillController,
                          percentageController: percentageController,
                          skills: skills,
                          onSkillsChanged: (updatedSkills) {
                            setState(() {
                              skills = updatedSkills;
                            });
                          },
                        ),
                        state: _currentStep > 2 ? StepState.complete : StepState
                            .indexed,
                        isActive: _currentStep >= 2,
                      ),
                      Step(
                        title: const Text('Experience',
                            style: TextStyle(color: Color(0xFF091057), fontSize: 20,

                              fontFamily: 'Roboto Slab',)),
                        content: ExperienceForm(
                          jobTitleController: jobTitleController,
                          companyController: companyController,
                          startDateController: startDate,
                          endDateController: endDate,
                          responsibilityController: responsibilityController,
                          experiences: experiences,
                          onExperiencesChanged: (updatedExperiences) {
                            setState(() {
                              experiences = updatedExperiences;
                            });
                          },
                        ),
                        state: _currentStep > 3 ? StepState.complete : StepState
                            .indexed,
                        isActive: _currentStep >= 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StudentProfileViewModel(),
      child: MaterialApp(
        home: ProfileStepper(userId: '6718e961d9aa2a38578d1bec'),
      ),
    ),
  );
}
