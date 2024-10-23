import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/views/Profil/UpdateSections/UpdateEducations.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/Custom_dropdown_field_profile.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';
import 'package:intl/intl.dart';

class ListeEducationPage extends StatefulWidget {
  final List<Education> education;
  final Function(Education) onEducationUpdated;

  const ListeEducationPage({
    Key? key,
    required this.education,
    required this.onEducationUpdated,
  }) : super(key: key);

  @override
  _ListeEducationPageState createState() => _ListeEducationPageState();
}

class _ListeEducationPageState extends State<ListeEducationPage> {
  late List<Education> education;

  @override
  void initState() {
    super.initState();
    education = List.from(widget.education);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _updateEducation(int index, Education updatedEducation) {
    setState(() {
      education[index] = updatedEducation;
    });
    widget.onEducationUpdated(updatedEducation);
  }

  Future<List<Education>> _loadEducation() async {
    await Future.delayed(const Duration(seconds: 1));
    return education;
  }

  void _showAddEducationDialog(BuildContext context) {
    TextEditingController degreeController = TextEditingController();
    TextEditingController institutionController = TextEditingController();
    TextEditingController specialtyController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5F2F2),
          title: const Text(
            'Add new Education',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Roboto Slab',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDropdownField(
                  labelText: 'Level of education',
                  icon: Icons.school,
                  value: degreeController.text.isEmpty
                      ? null
                      : degreeController.text,
                  hintText: 'Select your level of education',
                  items: const [
                    DropdownMenuItem(value: 'Bac', child: Text('Bac')),
                    DropdownMenuItem(value: 'Licence', child: Text('Licence')),
                    DropdownMenuItem(value: 'Master', child: Text('Master')),
                    DropdownMenuItem(
                        value: 'Ingénierie', child: Text('Ingénierie')),
                    DropdownMenuItem(
                        value: 'Doctorat', child: Text('Doctorat')),
                  ],
                  onChanged: (String? newValue) {
                    degreeController.text = newValue ?? '';
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: institutionController,
                  labelText: 'Institution name',
                  icon: Icons.business,
                  hintText: 'Enter your institution',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: specialtyController,
                  labelText: 'Field of study',
                  icon: Icons.book,
                  hintText: 'Enter your Field of study',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: startDateController,
                        labelText: 'Start Date',
                        icon: Icons.calendar_today,
                        hintText: 'Select start date',
                        isReadOnly: true,
                        onTap: () => _selectDate(context, startDateController),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // End Date
                    Expanded(
                      child: CustomTextField(
                        controller: endDateController,
                        labelText: 'End Date',
                        icon: Icons.calendar_today,
                        hintText: 'Select end date',
                        isReadOnly: true,
                        onTap: () => _selectDate(context, endDateController),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (degreeController.text.isNotEmpty &&
                    institutionController.text.isNotEmpty &&
                    specialtyController.text.isNotEmpty) {
                  try {
                    Education newEducation = Education(
                      degree: degreeController.text,
                      institution: institutionController.text,
                      specialite: specialtyController.text,
                      startDate: DateTime.parse(startDateController.text),
                      endDate: DateTime.parse(endDateController.text),
                    );

                    setState(() {
                      education.add(newEducation);
                    });
                    widget.onEducationUpdated(newEducation);
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid date format')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A6D8C),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F2F2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Center(
          child: Text(
            'Edit Education',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Roboto Slab',
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A6D8C),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF3A6D8C)),
            onPressed: () => _showAddEducationDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Education>>(
        future: _loadEducation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load education'));
          }

          final educationList = snapshot.data;

          if (educationList == null || educationList.isEmpty) {
            return const Center(child: Text('No education available.'));
          }

          return ListView.builder(
            itemCount: educationList.length,
            itemBuilder: (context, index) {
              final edu = educationList[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    '${edu.institution} \n${edu.degree} in ${edu.specialite} \nFrom ${edu.startDate.year} To ${edu.startDate.year} ',
                    style: const TextStyle(
                      fontFamily: 'Roboto Slab',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditEducationPage(
                            education: edu,
                            onEducationUpdated: (updatedEducation) {
                              _updateEducation(index, updatedEducation);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
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
