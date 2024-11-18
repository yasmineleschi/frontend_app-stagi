import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/views/Profil/Student/UpdateSections/updateSkills.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/CustomTextField_update.dart';

class ListeSkillsPage extends StatefulWidget {
  final List<Skill> skills;
  final Function(Skill) onSkillUpdated;

  const ListeSkillsPage({Key? key, required this.skills, required this.onSkillUpdated}) : super(key: key);

  @override
  _ListeSkillsPageState createState() => _ListeSkillsPageState();
}

class _ListeSkillsPageState extends State<ListeSkillsPage> {
  late List<Skill> skills;

  @override
  void initState() {
    super.initState();
    skills = widget.skills;
  }

  void _updateSkill(int index, Skill updatedSkill) {
    setState(() {
      skills[index] = updatedSkill;
    });
    widget.onSkillUpdated(updatedSkill);
  }

  Future<List<Skill>> _loadSkills() async {
    await Future.delayed(const Duration(seconds: 1));
    return skills;
  }

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
                backgroundColor: Colors.blueGrey,
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F2F2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Center(
          child: Text(
            'Edit Skills',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Roboto Slab',
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A6D8C),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF3A6D8C)),
            onPressed:  () => _showAddSkillDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Skill>>(
        future: _loadSkills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load skills'));
          }

          final skillsList = snapshot.data;

          if (skillsList == null || skillsList.isEmpty) {
            return const Center(child: Text('No skills available.'));
          }

          return ListView.builder(
            itemCount: skillsList.length,
            itemBuilder: (context, index) {
              final reverseIndex = skillsList.length - 1 - index;
              final skill = skillsList[reverseIndex];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    '${skill.name}   (${skill.percentage}%)',
                    style: const TextStyle(
                      fontFamily: 'Roboto Slab',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditSkillPage(
                            skill: skill,
                            onSkillUpdated: (updatedSkill) {
                              _updateSkill(index, updatedSkill);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
