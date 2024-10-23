import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/Custom_dropdown_field_profile.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';
import 'package:intl/intl.dart';

class EducationForm extends StatelessWidget {
  final TextEditingController degreeController;
  final TextEditingController institutionController;
  final TextEditingController specialitController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;

  EducationForm({
    required this.degreeController,
    required this.institutionController,
    required this.specialitController,
    required this.startDateController,
    required this.endDateController,
  });


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
  static bool isValid(BuildContext context, {
    required TextEditingController degreeController,
    required TextEditingController institutionController,
    required TextEditingController specialitController,
    required TextEditingController startDateController,
    required TextEditingController endDateController,
  }) {
    if (degreeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your degree')),
      );
      return false;
    }
    if (institutionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your institution')),
      );
      return false;
    }
    if (startDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date')),
      );
      return false;
    }
    if (endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an end date')),
      );
      return false;
    }
    if (specialitController.text.isEmpty) { // Add validation for speciality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your speciality')),
      );
      return false;
    }

    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdownField(
          labelText: 'Level of education',
          icon: Icons.school,
          value: degreeController.text.isEmpty ? null : degreeController.text,
          hintText: 'Select your level of education',
          items: const [
            DropdownMenuItem(value: 'Bac', child: Text('Bac')),
            DropdownMenuItem(value: 'Licence', child: Text('Licence')),
            DropdownMenuItem(value: 'Master', child: Text('Master')),
            DropdownMenuItem(value: 'Ingénierie', child: Text('Ingénierie')),
            DropdownMenuItem(value: 'Doctorat', child: Text('Doctorat')),
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
          controller: specialitController,
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
    );
  }
}