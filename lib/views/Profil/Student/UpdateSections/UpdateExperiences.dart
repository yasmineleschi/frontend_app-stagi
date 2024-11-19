import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/ConfirmationBottomSheet.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/CustomTextField_update.dart';
import 'package:intl/intl.dart';

class EditExperiencePage extends StatefulWidget {
  final Experience experience;
  final Function(Experience) onExperienceUpdated;

  const EditExperiencePage(
      {Key? key, required this.experience, required this.onExperienceUpdated})
      : super(key: key);

  @override
  _EditExperiencePageState createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _responsibilitiesController;
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
  void initState() {
    super.initState();
    _jobTitleController =
        TextEditingController(text: widget.experience.jobTitle);
    _companyController = TextEditingController(text: widget.experience.company);
    _startDateController = TextEditingController(
        text: widget.experience.startDate.toIso8601String().split("T").first);
    _endDateController = TextEditingController(
        text: widget.experience.endDate.toIso8601String().split("T").first);
    _responsibilitiesController = TextEditingController(
        text: widget.experience.responsibilities.join(", "));
  }

  void _updateExperience() {
    final Experience updatedExperience = widget.experience.copyWith(
      jobTitle: _jobTitleController.text,
      company: _companyController.text,
      startDate: DateTime.parse(_startDateController.text),
      endDate: DateTime.parse(_endDateController.text),
      responsibilities: _responsibilitiesController.text.split(', '),
    );

    widget.onExperienceUpdated(updatedExperience);
    Navigator.pop(context, updatedExperience);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showConfirmationBottomSheet(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F2F2),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F2F2),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Change Experience ',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF3A6D8C),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Job Title',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                labelText: '',
                initialValue: _jobTitleController.text,
                onChanged: (value) {
                  _jobTitleController.text = value;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Company',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                labelText: '',
                initialValue: _companyController.text,
                onChanged: (value) {
                  _companyController.text = value;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Start Date',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => _selectDate(context, _startDateController),
                child: AbsorbPointer(
                  child: CustomTextField(
                    labelText: '',
                    initialValue: _startDateController.text,
                    onChanged: (value) {},
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'End Date',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => _selectDate(context, _endDateController),
                child: AbsorbPointer(
                  child: CustomTextField(
                    labelText: '',
                    initialValue: _endDateController.text,
                    onChanged: (value) {},
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Responsibilities',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                maxLines: 3,
                labelText: '',
                initialValue: _responsibilitiesController.text,
                onChanged: (value) {
                  _responsibilitiesController.text = value;
                },
              ),
              const SizedBox(height: 16),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A6D8C),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _updateExperience,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationBottomSheet(
          title: 'Undo Changes?',
          message: 'Are you sure you want to discard the changes made?',
          onContinue: () {

          },
          onUndo: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
