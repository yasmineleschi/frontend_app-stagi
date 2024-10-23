import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/views/Profil/UpdateSections/liste_experience.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetViewProfile/widget_sections.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';
import 'package:intl/intl.dart';

class ExperienceSection extends StatefulWidget {
  final List<Experience> experiences;
  final Function(Experience) onExperienceUpdated;

  const ExperienceSection({Key? key, required this.experiences, required this.onExperienceUpdated}) : super(key: key);

  @override
  _ExperienceSectionState createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  bool _showAllExperiences = false;
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

  void _showAddExperienceDialog(BuildContext context) {
    TextEditingController jobTitleController = TextEditingController();
    TextEditingController companyController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5F2F2),
          title: const Text(
            'Add New Experience',
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
                  controller: jobTitleController,
                  labelText: 'Job Title',
                  icon: Icons.business,
                  hintText: 'Enter your job',
                ),
                const SizedBox(height: 10),
                CustomTextField(
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
                    child: const Text('Add Responsibility', style: TextStyle(color: Colors.white),),
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
            // Add Experience Button
            TextButton(
              onPressed: () {
                if (jobTitleController.text.isNotEmpty &&
                    companyController.text.isNotEmpty &&
                    startDateController.text.isNotEmpty &&
                    endDateController.text.isNotEmpty) {
                  Experience newExperience = Experience(
                    jobTitle: jobTitleController.text,
                    company: companyController.text,
                    startDate: DateTime.parse(startDateController.text),
                    endDate: DateTime.parse(endDateController.text),
                    responsibilities: List.from(responsibilities),
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
            // Cancel Button
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
    if (widget.experiences.isEmpty) {
      return const Center(child: Text('No experiences available.'));
    }

    final displayedExperiences = _showAllExperiences ? widget.experiences : widget.experiences.take(3).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          ProfileSectionCard(
            title: 'Experience',
            content: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: displayedExperiences.map((experience) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${experience.jobTitle} at ${experience.company}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text('From ${experience.startDate.year} to ${experience.endDate.year}'),
                        const SizedBox(height: 5),
                        Text('Responsibilities:\n${experience.responsibilities.join(', ')}'),
                        const SizedBox(height: 15),
                      ],
                    );
                  }).toList(),
                ),
                Positioned(
                  right: 5.0,
                  bottom: 0.0,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showAllExperiences = !_showAllExperiences;
                      });
                    },
                    child: Text(
                      _showAllExperiences ? 'See Less..' : 'See More..',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto Slab',
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            icon: Icons.work_outline,
            hasAddIcon: () => _showAddExperienceDialog(context),
            onEditPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListeExperiencePage(
                    experiences: widget.experiences,
                    onExperienceUpdated: widget.onExperienceUpdated,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
