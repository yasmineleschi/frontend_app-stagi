import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';
import 'package:intl/intl.dart';

class ExperienceForm extends StatefulWidget {
  final TextEditingController jobTitleController;
  final TextEditingController companyController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController responsibilityController;
  final List<Experience> experiences;
  final Function(List<Experience>) onExperiencesChanged;

  ExperienceForm({
    required this.jobTitleController,
    required this.companyController,
    required this.startDateController,
    required this.endDateController,
    required this.responsibilityController,
    required this.experiences,
    required this.onExperiencesChanged,
  });

  @override
  _ExperienceFormState createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
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


  void _addExperience() {
    if (widget.jobTitleController.text.isNotEmpty &&
        widget.companyController.text.isNotEmpty &&
        widget.startDateController.text.isNotEmpty &&
        widget.endDateController.text.isNotEmpty) {
      setState(() {
        widget.experiences.add(Experience(
          jobTitle: widget.jobTitleController.text,
          company: widget.companyController.text,
          startDate: DateTime.parse(widget.startDateController.text),
          endDate: DateTime.parse(widget.endDateController.text),
          responsibilities: List.from(responsibilities),
        ));
        widget.onExperiencesChanged(widget.experiences);
      });
      widget.jobTitleController.clear();
      widget.companyController.clear();
      widget.startDateController.clear();
      widget.endDateController.clear();
      responsibilities.clear();
    }
  }


  void _addResponsibility() {
    if (widget.responsibilityController.text.isNotEmpty) {
      setState(() {
        responsibilities.add(widget.responsibilityController.text);
      });
      widget.responsibilityController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Entrée des expériences
        CustomTextField(
          controller: widget.jobTitleController,
          labelText: 'Job Title',
          icon: Icons.work,
          hintText: 'Enter job title',
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: widget.companyController,
          labelText: 'Company',
          icon: Icons.business,
          hintText: 'Enter company name',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Date de début
            Expanded(
              child: CustomTextField(
                controller: widget.startDateController,
                labelText: 'Start Date',
                icon: Icons.calendar_today,
                hintText: 'Select start date',
                isReadOnly: true,
                onTap: () => _selectDate(context, widget.startDateController),
              ),
            ),
            const SizedBox(width: 20),

            // Date de fin
            Expanded(
              child: CustomTextField(
                controller: widget.endDateController,
                labelText: 'End Date',
                icon: Icons.calendar_today,
                hintText: 'Select end date',
                isReadOnly: true,
                onTap: () => _selectDate(context, widget.endDateController),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),


        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: widget.responsibilityController,
                labelText: 'Responsibility',
                icon: Icons.task,
                hintText: 'Enter responsibility',
              ),
            ),
            ElevatedButton(
              onPressed: _addResponsibility,
              child: const Text('Add Responsibility'),
            ),
          ],
        ),
        const SizedBox(height: 10),


        if (responsibilities.isNotEmpty)
          Column(
            children: responsibilities.map((responsibility) {
              return ListTile(
                title: Text(
                  responsibility,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 10),


        ElevatedButton(
          onPressed: _addExperience,
          child: const Text('Add Experience'),
        ),
      ],
    );
  }
}
