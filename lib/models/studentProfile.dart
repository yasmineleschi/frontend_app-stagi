class StudentProfile {
  String? userId;
  final String firstName;
  final String lastName;
  final String phone;
  final String bio;
  final String specialite;
  final String location;
  final List<Education> education;
  final List<Skill> skills;
  final List<Experience> experience;

  StudentProfile({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.bio = "No bio available",
    this.specialite = "No specialty available",
    this.location = "Not specified",
    required this.education,
    required this.skills,
    required this.experience,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? 'No bio available',
      specialite: json['specialite'] ?? 'No specialty available',
      location: json['location'] ?? 'Not specified',
      education: (json['education'] as List?)
          ?.map((e) => Education.fromJson(e))
          .toList() ??
          [],
      skills: (json['skills'] as List?)
          ?.map((e) => Skill.fromJson(e))
          .toList() ??
          [],
      experience: (json['experience'] as List?)
          ?.map((e) => Experience.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'specialite': specialite,
      'bio': bio,
      'location': location,
      'education': education.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'experience': experience.map((e) => e.toJson()).toList(),
    };
  }
}

class Education {
  final String degree;
  final String institution;
  final DateTime startDate;
  final DateTime endDate;

  Education({
    required this.degree,
    required this.institution,
    required this.startDate,
    required this.endDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'] ?? '',
      institution: json['institution'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}


class Skill {
  final String name;
  final int percentage;

  Skill({
    required this.name,
    required this.percentage,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] ?? '',
      percentage: json['percentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'percentage': percentage,
    };
  }
}

class Experience {
  final String jobTitle;
  final String company;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> responsibilities;

  Experience({
    required this.jobTitle,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.responsibilities,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      jobTitle: json['jobTitle'] ?? '',
      company: json['company'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toString()),
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'company': company,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'responsibilities': responsibilities,
    };
  }
}
