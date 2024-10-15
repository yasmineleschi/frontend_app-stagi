import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';

class SkillsSection extends StatefulWidget {
  final List<Skill> skills;

  SkillsSection({required this.skills});

  @override
  _SkillsSectionState createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre "Skills"
          const Text(
            'Skills',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),


          Column(
            children: widget.skills.map((skill) => SkillItem(skill: skill)).toList(),
          ),
        ],
      ),
    );
  }
}

class SkillItem extends StatelessWidget {
  final Skill skill;

  SkillItem({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            skill.name,
            style: const TextStyle(fontSize: 14),
          ),
          Container(
            width: 100,
            child: LinearProgressIndicator(
              value: skill.percentage / 100,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 10),
          Text(
            '${skill.percentage}%',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
