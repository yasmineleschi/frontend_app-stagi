import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/widgets/WidgetsCreateProfile/costum_widget_profile.dart';
import 'package:intl/intl.dart';

class EducationForm extends StatelessWidget {
  final TextEditingController degreeController;
  final TextEditingController institutionController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;

  EducationForm({
    required this.degreeController,
    required this.institutionController,
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
      controller.text = DateFormat('yyyy-MM-dd').format(picked);  // Formate la date
    }
  }
  static bool isValid(BuildContext context, {
    required TextEditingController degreeController,
    required TextEditingController institutionController,
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

    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: degreeController,
          labelText: 'Degree',
          icon: Icons.school,
          hintText: 'Enter your degree',
        ),
        const SizedBox(height: 20),

        CustomTextField(
          controller: institutionController,
          labelText: 'Institution',
          icon: Icons.business,
          hintText: 'Enter your institution',
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
