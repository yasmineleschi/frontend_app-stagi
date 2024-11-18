import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/ConfirmationBottomSheet.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/CustomTextField_update.dart'; // Import du CustomTextField

class EditSkillPage extends StatefulWidget {
  final Skill skill;
  final Function(Skill) onSkillUpdated;

  const EditSkillPage(
      {Key? key, required this.skill, required this.onSkillUpdated})
      : super(key: key);

  @override
  _EditSkillPageState createState() => _EditSkillPageState();
}

class _EditSkillPageState extends State<EditSkillPage> {
  late TextEditingController _skillNameController;
  late TextEditingController _skillPercentageController;

  @override
  void initState() {
    super.initState();
    _skillNameController = TextEditingController(text: widget.skill.name);
    _skillPercentageController =
        TextEditingController(text: widget.skill.percentage.toString());
  }

  void _updateSkill() {
    final String updatedName = _skillNameController.text;
    final int updatedPercentage = int.parse(_skillPercentageController.text);

    Skill updatedSkill = widget.skill.copyWith(
      name: updatedName,
      percentage: updatedPercentage,
    );

    widget.onSkillUpdated(updatedSkill);
    Navigator.pop(context, updatedSkill);
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
                'Skill Name : ',
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
                initialValue: _skillNameController.text,
                onChanged: (value) {
                  _skillNameController.text = value;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Skill Percentage : ',
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
                initialValue: _skillPercentageController.text,
                onChanged: (value) {
                  _skillPercentageController.text = value;
                },
                maxLines: 1,
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
                    onPressed: _updateSkill,
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
