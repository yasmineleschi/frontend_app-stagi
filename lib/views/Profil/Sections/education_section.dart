import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/views/Profil/Forms/institution_autocomplete.dart';
import 'package:frontend_app_stagi/views/Profil/UpdateSections/liste_education.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetViewProfile/widget_sections.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/Custom_dropdown_field_profile.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';
import 'package:intl/intl.dart';

class EducationSection extends StatefulWidget {
  final List<Education> educationList;
  final Function(Education) onEducationUpdated;

  const EducationSection(
      {Key? key, required this.educationList, required this.onEducationUpdated})
      : super(key: key);

  @override
  _EducationSectionState createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  bool _showAllEducation = false;
  List<String> filteredInstitutions = [];
  bool showInstitutionSuggestions = false;


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
            'Add New Education',
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
                InstitutionAutocomplete(controller: institutionController),
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
                    institutionController.text.isNotEmpty) {
                  Education newEducation = Education(
                    degree: degreeController.text,
                    institution: institutionController.text,
                    specialite: specialtyController.text,
                    startDate: DateTime.parse(startDateController.text),
                    endDate: DateTime.parse(endDateController.text),
                  );

                  setState(() {
                    widget.educationList.add(newEducation);
                  });
                  widget.onEducationUpdated(newEducation);
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

    final displayedEducation = _showAllEducation
        ? widget.educationList
        : widget.educationList.take(3).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          ProfileSectionCard(
            title: 'Education',
            content: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: displayedEducation.map((education) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${education.institution}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text('${education.degree} in ${education.specialite}'),
                        const SizedBox(height: 5),
                        Text(
                            'From ${education.startDate.year} to ${education.endDate.year}'),
                        const SizedBox(height: 15),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
            icon: Icons.school_outlined,
            hasAddIcon: () => _showAddEducationDialog(context),
            onEditPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListeEducationPage(
                    education: widget.educationList,
                    onEducationUpdated: widget.onEducationUpdated,
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
