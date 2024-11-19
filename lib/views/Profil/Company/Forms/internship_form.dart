import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/company.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';
import 'package:intl/intl.dart';

class InternshipForm extends StatefulWidget {
  final List<Internship> internships;


  InternshipForm({
    required this.internships,

  });

  @override
  _InternshipFormState createState() => _InternshipFormState();
}

class _InternshipFormState extends State<InternshipForm> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController requirementsController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  bool isActive = false;


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


  void _addInternship() {
    if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && startDateController.text.isNotEmpty && endDateController.text.isNotEmpty) {
      setState(() {
        widget.internships.add(Internship(
          title: titleController.text,
          description: descriptionController.text,
          requirements: requirementsController.text.split('\n'),
          startDate: DateTime.parse(startDateController.text),
          endDate: DateTime.parse(endDateController.text),
          postedDate: DateTime.now(),
          isActive: isActive,
          companyName:  "",
            companyAddress: ""
        ));

      });
      titleController.clear();
      descriptionController.clear();
      locationController.clear();
      requirementsController.clear();
      startDateController.clear();
      endDateController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        CustomTextField(
          controller: titleController,
          labelText: 'Internship Title',
          icon: Icons.work_outline,
          hintText: 'Enter the title of the internship',
        ),
        const SizedBox(height: 20),


        CustomTextField(
          controller: descriptionController,
          labelText: 'Description',
          icon: Icons.description_outlined,
          hintText: 'Describe the internship details',
          maxLines: 6,
        ),
        const SizedBox(height: 20),


        CustomTextField(
          controller: requirementsController,
          labelText: 'Requirements',
          icon: Icons.check_circle_outline,
          hintText: 'List the requirements',
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: startDateController,
                labelText: 'Start Date',
                icon: Icons.date_range_outlined,
                hintText: 'Select the start date',
                isReadOnly: true,
                onTap: () => _selectDate(context, startDateController),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: CustomTextField(
                controller: endDateController,
                labelText: 'End Date',
                icon: Icons.date_range_outlined,
                hintText: 'Select the end date',
                isReadOnly: true,
                onTap: () => _selectDate(context, endDateController),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Text('Active:'),
            Switch(
              value: isActive,
              onChanged: (bool value) {
                setState(() {
                  isActive = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Add Internship Button
        ElevatedButton(
          onPressed: _addInternship,
          child: const Text('Add Internship'),
        ),

      ],
    );
  }
}
