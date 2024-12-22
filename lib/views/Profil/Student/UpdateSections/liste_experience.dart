import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/views/Profil/Student/UpdateSections/UpdateExperiences.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';
import 'package:intl/intl.dart';

class ListeExperiencePage extends StatefulWidget {
  final List<Experience> experiences;
  final Function(Experience) onExperienceUpdated;

  const ListeExperiencePage(
      {Key? key, required this.experiences, required this.onExperienceUpdated})
      : super(key: key);

  @override
  _ListeExperiencePagePageState createState() =>
      _ListeExperiencePagePageState();
}

class _ListeExperiencePagePageState extends State<ListeExperiencePage> {
  late List<Experience> experiences;
  TextEditingController responsibilitiesController = TextEditingController();
  List<String> responsibilities = [];

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
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

  void _addResponsibility() {
    if (responsibilitiesController.text.isNotEmpty) {
      setState(() {
        responsibilities.add(responsibilitiesController.text);
      });
      responsibilitiesController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    experiences = widget.experiences;
  }

  void _updateExperience(int index, Experience updatedExperience) {
    setState(() {
      experiences[index] = updatedExperience;
    });
    widget.onExperienceUpdated(updatedExperience);
  }

  Future<List<Experience>> _loadExperiences() async {
    await Future.delayed(const Duration(seconds: 1));
    return experiences;
  }

  void _showAddExperienceDialog(BuildContext context) {
    TextEditingController jobTitleController = TextEditingController();
    TextEditingController companyController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();
    TextEditingController responsibilitiesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5F2F2),
          title: const Text(
            'Add new Experience',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Roboto Slab',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  key: const Key('usernameField'),
                  controller: jobTitleController,
                  labelText: 'Job Title',
                  icon: Icons.business,
                  hintText: 'Enter your job',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  key: const Key('usernameField'),
                  controller: companyController,
                  labelText: 'Company Name',
                  icon: Icons.business,
                  hintText: 'Enter your company name',
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        key: const Key('usernameField'),
                        controller: startDateController,
                        labelText: 'Start Date',
                        icon: Icons.calendar_today,
                        hintText: 'Select start date',
                        isReadOnly: true,
                        onTap: () => _selectDate(context, startDateController),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomTextField(
                        key: const Key('usernameField'),
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
                const SizedBox(height: 10),
                CustomTextField(
                  key: const Key('usernameField'),
                  controller: responsibilitiesController,
                  labelText: 'Responsibility',
                  icon: Icons.task,
                  hintText: 'Enter your responsibility',
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _addResponsibility,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A6D8C),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Add Responsibility',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (responsibilities.isNotEmpty)
                  Column(
                    children: responsibilities.map((responsibility) {
                      return ListTile(
                        title: Text(
                          responsibility,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (jobTitleController.text.isNotEmpty &&
                    companyController.text.isNotEmpty) {
                  Experience newExperience = Experience(
                    jobTitle: jobTitleController.text,
                    company: companyController.text,
                    startDate: DateTime.parse(startDateController.text),
                    endDate: DateTime.parse(endDateController.text),
                    responsibilities:
                        responsibilitiesController.text.split(','),
                  );

                  setState(() {
                    widget.experiences.add(newExperience);
                  });
                  widget.onExperienceUpdated(newExperience);
                  Navigator.of(context).pop();
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
                backgroundColor: Colors.blueGrey,
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
            'Edit Experience',
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
            onPressed: () => _showAddExperienceDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Experience>>(
        future: _loadExperiences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load experiences'));
          }

          final experiencesList = snapshot.data;

          if (experiencesList == null || experiencesList.isEmpty) {
            return const Center(child: Text('No experiences available.'));
          }

          return ListView.builder(
            itemCount: experiencesList.length,
            itemBuilder: (context, index) {
              final reverseIndex = experiencesList.length - 1 - index;
              final experience = experiencesList[reverseIndex];
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
                    '${experience.jobTitle} at ${experience.company} \n From ${experience.startDate.year} TO ${experience.endDate.year} \n Responsibilities : ${experience.responsibilities.join(', ')} ',
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
                          builder: (context) => EditExperiencePage(
                            experience: experience,
                            onExperienceUpdated: (updateExperience) {
                              _updateExperience(index, updateExperience);
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
