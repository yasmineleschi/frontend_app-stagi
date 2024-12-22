import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart'; // Ensure this path is correct

class DescriptionForm extends StatefulWidget {
  final TextEditingController descriptionController;
  final TextEditingController yearFoundedController;
  final TextEditingController employeeCountController;

  DescriptionForm({
    required this.descriptionController,
    required this.yearFoundedController,
    required this.employeeCountController,
  });

  @override
  _DescriptionFormState createState() => _DescriptionFormState();
}

class _DescriptionFormState extends State<DescriptionForm> {
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.year.toString().padLeft(4, '0')}-"
            "${pickedDate.month.toString().padLeft(2, '0')}-"
            "${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          key: const Key('usernameField'),
          controller: widget.descriptionController,
          labelText: 'Company Description',
          icon: Icons.description_outlined,
          hintText: 'Tell us about your company',
          maxLines: 6,
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: CustomTextField(
                key: const Key('usernameField'),
                controller: widget.employeeCountController,
                labelText: 'Number of Employees',
                icon: Icons.groups_outlined,
                hintText: 'Enter the employee count',
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: CustomTextField(
                key: const Key('usernameField'),
                controller: widget.yearFoundedController,
                labelText: 'Year Founded',
                icon: Icons.date_range_outlined,
                hintText: 'Select the year founded',
                isReadOnly: true,
                onTap: () => _selectDate(context, widget.yearFoundedController),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
