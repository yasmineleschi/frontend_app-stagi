import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';

class ExperienceSection extends StatelessWidget {
  final List<Experience> experiences;

  ExperienceSection({required this.experiences});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
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
          const Text(
            'Experience',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: experiences.map((exp) => ExperienceItem(experience: exp)).toList(),
          ),
        ],
      ),
    ),
    );
  }
}

class ExperienceItem extends StatelessWidget {
  final Experience experience;

  ExperienceItem({required this.experience});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${experience.jobTitle} at ${experience.company}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            '${experience.startDate.year} - ${experience.endDate.year}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          const Text(
            'Responsibilities:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          ...experience.responsibilities.map((responsibility) => Text(
            '- $responsibility',
            style: const TextStyle(fontSize: 12),
          )).toList(),
        ],
      ),
    );
  }
}
