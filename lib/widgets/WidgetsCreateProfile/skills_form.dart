import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/widgets/WidgetsCreateProfile/costum_widget_profile.dart';

class SkillsForm extends StatefulWidget {
  final TextEditingController skillController;
  final TextEditingController percentageController;
  final List<Skill> skills;
  final Function(List<Skill>) onSkillsChanged;

  SkillsForm({
    required this.skillController,
    required this.percentageController,
    required this.skills,
    required this.onSkillsChanged,
  });

  @override
  _SkillsFormState createState() => _SkillsFormState();
}

class _SkillsFormState extends State<SkillsForm> {
  void _addSkill() {
    if (widget.skillController.text.isNotEmpty &&
        widget.percentageController.text.isNotEmpty) {
      setState(() {
        int percentage = int.tryParse(widget.percentageController.text) ?? 0;
        widget.skills.add(Skill(
          name: widget.skillController.text,
          percentage: percentage,
        ));
        widget.onSkillsChanged(widget.skills);
      });
      widget.skillController.clear();
      widget.percentageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: widget.skillController,
                labelText: 'Skill',
                icon: Icons.star,
                hintText: 'Enter your skill',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  CustomTextField(
                    controller: widget.percentageController,
                    labelText: 'Percentage (0-100)',
                    icon: Icons.percent,
                    hintText: 'Enter percentage',
                    isPhoneField: false,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _addSkill,
          child: const Text('Add Skill'),
        ),
        const SizedBox(height: 20),
        if (widget.skills.isNotEmpty)
          Column(
            children: widget.skills.map((skill) {
              return Container(
                child:   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        skill.name,
                        style: const TextStyle(color: Color(0xFF091057) , fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '${skill.percentage}%',
                        style: const TextStyle(color: Color(0xFF091057) , fontSize: 16),
                      ),
                    ],
                  )
              ) ;
            }).toList(),
          ),
      ],
    );
  }
}
