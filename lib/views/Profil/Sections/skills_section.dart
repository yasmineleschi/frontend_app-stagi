import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/views/Profil/UpdateSections/liste_skils.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetViewProfile/widget_sections.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/CustomTextField_update.dart';

class SkillsSection extends StatefulWidget {
  final List<Skill> skills;
  final Function(Skill) onSkillUpdated;

  const SkillsSection({Key? key, required this.skills, required this.onSkillUpdated}) : super(key: key);

  @override
  _SkillsSectionState createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  bool _showAllSkills = false;

  void _showAddSkillDialog(BuildContext context) {
    TextEditingController skillController = TextEditingController();
    TextEditingController percentageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:  const Color(0xFFF5F2F2),
          title: const Text('Add new Skill',
            style: TextStyle(
            fontSize: 20,
            fontFamily: 'Roboto Slab',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),),
          content: SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextField(
                    labelText: 'Skill Name',
                    onChanged: (value) {
                      skillController.text = value;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    labelText: 'Percentage (0-100)',
                    onChanged: (value) {
                      percentageController.text = value;
                    },
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A6D8C),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                if (skillController.text.isNotEmpty &&
                    percentageController.text.isNotEmpty) {
                  int percentage = int.tryParse(percentageController.text) ?? 0;
                  Skill newSkill = Skill(
                    name: skillController.text,
                    percentage: percentage,
                  );

                  setState(() {
                    widget.skills.add(newSkill);
                  });
                  widget.onSkillUpdated(newSkill);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add' ,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Cancel',
        style: TextStyle(
        fontSize: 15,
        color: Colors.white,
        ),),
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.skills.isEmpty) {
      return const Center(child: Text('No skills available.'));
    }


    final displayedSkills = _showAllSkills ? widget.skills : widget.skills.take(3).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          ProfileSectionCard(
            title: 'Skills',
            content: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: displayedSkills.map((skill) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${skill.name} (${skill.percentage}%)',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        LinearProgressIndicator(
                          value: skill.percentage / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey[100],
                          color: const Color(0xFF879DBA),
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10,),

                Positioned(
                  right: 5.0,
                  bottom: 0.0,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showAllSkills = !_showAllSkills;
                      });
                    },
                    child: Text(
                      _showAllSkills ? 'See Less..' : 'See More..',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto Slab',
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            icon: Icons.star_border_outlined,
            hasAddIcon: () => _showAddSkillDialog(context),
            onEditPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListeSkillsPage(
                    skills: widget.skills,
                    onSkillUpdated: widget.onSkillUpdated,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
