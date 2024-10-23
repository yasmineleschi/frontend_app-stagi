import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/ConfirmationBottomSheet.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/CustomTextField_update.dart';
import 'package:intl/intl.dart';

class EditEducationPage extends StatefulWidget {
  final Education education;
  final Function(Education) onEducationUpdated;

  const EditEducationPage({Key? key, required this.education, required this.onEducationUpdated}) : super(key: key);

  @override
  _EditEducationPageState createState() => _EditEducationPageState();
}

class _EditEducationPageState extends State<EditEducationPage> {
  late TextEditingController _degreeController;
  late TextEditingController _institutionController;
  late TextEditingController _specialtyController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _degreeController = TextEditingController(text: widget.education.degree);
    _institutionController = TextEditingController(text: widget.education.institution);
    _specialtyController = TextEditingController(text: widget.education.specialite);
    _startDateController = TextEditingController(text: widget.education.startDate.toIso8601String().split("T").first);
    _endDateController = TextEditingController(text: widget.education.endDate.toIso8601String().split("T").first);
  }
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
  void _updateEducation() {
    final Education updatedEducation = widget.education.copyWith(
      degree: _degreeController.text,
      institution: _institutionController.text,
      specialite: _specialtyController.text,
      startDate: DateTime.parse(_startDateController.text),
      endDate: DateTime.parse(_endDateController.text),
    );

    widget.onEducationUpdated(updatedEducation);
    Navigator.pop(context, updatedEducation);
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
                'Change Education ',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF3A6D8C),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Level of education ',
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
                initialValue: _degreeController.text,
                onChanged: (value) {
                  _degreeController.text = value;
                },
              ),
              const SizedBox(height: 15),
              const Text(
                'Institution name',
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
                initialValue: _institutionController.text,
                onChanged: (value) {
                  _institutionController.text = value;
                },
              ),
              const SizedBox(height: 15),
              const Text(
                'Field of study',
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
                initialValue: _specialtyController.text,
                onChanged: (value) {
                  _specialtyController.text = value;
                },
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
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
                    onPressed: _updateEducation,
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
