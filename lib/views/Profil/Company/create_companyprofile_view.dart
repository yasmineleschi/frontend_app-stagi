import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/company.dart';
import 'package:frontend_app_stagi/viewmodels/company_viewmodel.dart';
import 'package:frontend_app_stagi/views/Profil/Company/Forms/basic_info_form.dart';
import 'package:frontend_app_stagi/views/Profil/Company/Forms/description_form.dart';
import 'package:frontend_app_stagi/views/Profil/Company/Forms/internship_form.dart';
import 'package:frontend_app_stagi/views/Profil/Company/company_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CompanyProfileStepper extends StatefulWidget {
  final String userId;

  CompanyProfileStepper({required this.userId});

  @override
  _ProfileStepperState createState() => _ProfileStepperState();
}

class _ProfileStepperState extends State<CompanyProfileStepper> {
  int _currentStep = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController sectorController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController employeeCountController = TextEditingController();
  final TextEditingController yearFoundedController = TextEditingController();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();
  final TextEditingController RequirementsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController postedDate = TextEditingController();
  final TextEditingController isActiveController = TextEditingController();

  List<Internship> internships = [];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CompanyProfileViewModel>(context);

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
                    primaryColor: const Color(0xFF3A6D8C),
                    colorScheme:
                        const ColorScheme.light(primary: Color(0xFF3A6D8C)),
                    dividerColor: const Color(0xFF3A6D8C),
                  ),
                  child: Stepper(
                    currentStep: _currentStep,
                    onStepContinue: () async {
                      if (_currentStep < 2) {
                        if (_currentStep == 0) {
                          if (BasicInfoForm.isValid(
                            context,
                            nameController: nameController,
                            sectorController: sectorController,
                            phoneNumberController: phoneNumberController,
                            addressController: addressController,
                            websiteController: websiteController,
                          )) {
                            setState(() => _currentStep++);
                          }
                        } else if (_currentStep < 2) {
                          setState(() => _currentStep++);
                        }
                      } else {
                        bool shouldProceed = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Confirmation',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontFamily: 'Roboto Slab',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF091057),
                                ),
                              ),
                              content: const Text(
                                'Are you sure you want to continue and create your profile?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Roboto Slab',
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                      fontFamily: 'Roboto Slab',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                      fontFamily: 'Roboto Slab',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldProceed) {


                          Company profile = Company(
                            userId: widget.userId,
                            name: nameController.text,
                            sector: sectorController.text,
                            address: addressController.text,
                            phoneNumber: phoneNumberController.text,
                            website: websiteController.text,
                            description: descriptionController.text,
                            yearFounded: DateTime.parse(yearFoundedController.text),
                            employeeCount: employeeCountController.text,
                            internships: internships,
                          );


                          bool success = await viewModel.createCompanyProfile(profile, widget.userId);

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
                                builder: (context) =>
                                    CompanyProfileView(userId: widget.userId),
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
                        title: const Text(
                          'Basic Info',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF091057),
                            fontFamily: 'Roboto Slab',
                          ),
                        ),
                        content: Column(
                          children: [

                            const SizedBox(height: 10),
                            BasicInfoForm(
                              nameController: nameController,
                              sectorController: sectorController,
                              addressController: addressController,
                              phoneNumberController: phoneNumberController,
                              websiteController: websiteController,
                            ),
                          ],
                        ),
                        state: _currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                        isActive: _currentStep >= 0,
                      ),
                      Step(
                        title: const Text('Description ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF091057),
                              fontFamily: 'Roboto Slab',
                            )),
                        content: DescriptionForm(
                          descriptionController: descriptionController,
                          employeeCountController: employeeCountController,
                          yearFoundedController: yearFoundedController,
                        ),
                        state: _currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                        isActive: _currentStep >= 1,
                      ),
                      Step(
                        title: const Text('Internship',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF091057),
                              fontFamily: 'Roboto Slab',
                            )),
                        content: InternshipForm(internships: internships,),
                        state: _currentStep > 2
                            ? StepState.complete
                            : StepState.indexed,
                        isActive: _currentStep >= 2,
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
      create: (context) => CompanyProfileViewModel(),
      child: MaterialApp(
        home: CompanyProfileStepper(userId: '672cca0757f81eaffe7c119f'),
      ),
    ),
  );
}
