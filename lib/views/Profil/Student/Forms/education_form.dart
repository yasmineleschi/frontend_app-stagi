import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Forms/institution_autocomplete.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/Custom_dropdown_field_profile.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';
import 'package:intl/intl.dart';

class EducationForm extends StatefulWidget {
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

  @override
  _EducationFormState createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdownField(
          labelText: 'Level of education',
          icon: Icons.school,
          value: widget.degreeController.text.isEmpty ? null : widget.degreeController.text,
          hintText: 'Select your level of education',
          items: const [
            DropdownMenuItem(value: 'Bac', child: Text('Bac')),
            DropdownMenuItem(value: 'Licence', child: Text('Licence')),
            DropdownMenuItem(value: 'Master', child: Text('Master')),
            DropdownMenuItem(value: 'Ingénierie', child: Text('Ingénierie')),
            DropdownMenuItem(value: 'Doctorat', child: Text('Doctorat')),
          ],
          onChanged: (String? newValue) {
            widget.degreeController.text = newValue ?? '';
          },
        ),
        const SizedBox(height: 20),
        InstitutionAutocomplete(
            key: const Key('institutionField'),
            controller: widget.institutionController),
        const SizedBox(height: 20),

        CustomTextField(
          key: const Key('specialityEducationField'),
          controller: widget.specialitController,
          labelText: 'Field of study',
          icon: Icons.book,
          hintText: 'Enter your Field of study',
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: CustomTextField(
                key: const Key('startDateField'),
                controller: widget.startDateController,
                labelText: 'Start Date',
                icon: Icons.calendar_today,
                hintText: 'Select start date',
                isReadOnly: true,
                onTap: () => _selectDate(context, widget.startDateController),
              ),
            ),
            const SizedBox(width: 20),

            Expanded(
              child: CustomTextField(
                key: const Key('endDateField'),
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
      ],
    );
  }
}
