import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/company.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/ConfirmationBottomSheet.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/CustomTextField_update.dart'; // Import du CustomTextField

class EditInternshipPage extends StatefulWidget {
  final Internship internship;
  final Function(Internship) onInternshipUpdated;

  const EditInternshipPage({
    Key? key,
    required this.internship,
    required this.onInternshipUpdated,
  }) : super(key: key);

  @override
  _EditInternshipPageState createState() => _EditInternshipPageState();
}

class _EditInternshipPageState extends State<EditInternshipPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _requirementsController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.internship.title);
    _descriptionController =
        TextEditingController(text: widget.internship.description);
    _requirementsController =
        TextEditingController(text: widget.internship.requirements.join(', '));
    _startDateController = TextEditingController(
        text: widget.internship.startDate.toIso8601String().split("T").first);
    _endDateController = TextEditingController(
        text: widget.internship.endDate.toIso8601String().split("T").first);
    isActive = widget.internship.isActive;
  }

  void _updateInternship() {
    final String updatedTitle = _titleController.text;
    final String updatedDescription = _descriptionController.text;
    final List<String> updatedRequirements = _requirementsController.text.split(', ').map((e) => e.trim()).toList();
    final DateTime updatedStartDate = DateTime.parse(_startDateController.text);
    final DateTime updatedEndDate = DateTime.parse(_endDateController.text);

    // Make sure the internship object is structured properly for the API
    Internship updatedInternship = widget.internship.copyWith(
      title: updatedTitle,
      description: updatedDescription,
      requirements: updatedRequirements,
      startDate: updatedStartDate,
      endDate: updatedEndDate,
      isActive: isActive,
    );

    // Update internship in parent widget
    widget.onInternshipUpdated(updatedInternship);

    // Pop and return updated internship to previous screen
    Navigator.pop(context, updatedInternship);
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
                'Change Internship ',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF3A6D8C),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Internship Title',
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
                initialValue: _titleController.text,
                onChanged: (value) {
                  _titleController.text = value;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Description',
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
                initialValue: _descriptionController.text,
                onChanged: (value) {
                  _descriptionController.text = value;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const Text(
                'Requirements',
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
                initialValue: _requirementsController.text,
                onChanged: (value) {
                  _requirementsController.text = value;
                },
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child:
                    Column(
                    children: [
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
                      CustomTextField(
                        labelText: '',
                        initialValue: _startDateController.text,
                        onChanged: (value) {
                          _startDateController.text = value;
                        },
                      ),
                    ],
                  ), ),
                  const SizedBox(width: 10,),
                  Expanded(child: Column(
                    children: [
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
                      CustomTextField(
                        labelText: '',
                        initialValue: _endDateController.text,
                        onChanged: (value) {
                          _endDateController.text = value;
                        },
                      ),
                    ],
                  ), )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Active',style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto Slab',
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),),
                  const SizedBox(width: 10,),
                  Switch(
                    activeColor:  Color(0xFF3A6D8C),
                    value: isActive,
                    onChanged: (bool value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                ],
              ),
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
                    onPressed: _updateInternship,
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
            // Code for discarding changes
            Navigator.of(context).pop();
          },
          onUndo: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
