class StudentProfile {
  String? userId;
  String firstName;
  String lastName;
  String phone;
  String? bio;
  String specialite;
  String location;
  String? profileImage;
  List<Education> education;
  List<Skill> skills;
  List<Experience> experience;

  StudentProfile({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.bio,
    required this.specialite,
    required this.location,
    this.profileImage,
    required this.education,
    required this.skills,
    required this.experience,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      userId: json['userId'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      bio: json['bio'] as String? ?? 'No bio available',
      specialite: json['specialite'] as String? ?? 'No specialty available',
      location: json['location'] as String? ?? 'Not specified',
      profileImage: json['profileImage'] as String?,
      education: (json['education'] as List<dynamic>?)
          ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      experience: (json['experience'] as List<dynamic>?)
          ?.map((e) => Experience.fromJson(e as Map<String, dynamic>))
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
      'profileImage': profileImage,
      'education': education.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'experience': experience.map((e) => e.toJson()).toList(),
    };
  }

  StudentProfile copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? phone,
    String? bio,
    String? specialite,
    String? location,
    String? profileImage,
    List<Education>? education,
    List<Skill>? skills,
    List<Experience>? experience,
  }) {
    return StudentProfile(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      specialite: specialite ?? this.specialite,
      location: location ?? this.location,
      profileImage: profileImage ?? this.profileImage,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
    );
  }
}

class Education {
  final String degree;
  final String institution;
  final String specialite;
  final DateTime startDate;
  final DateTime endDate;

  Education({
    required this.degree,
    required this.institution,
    required this.specialite,
    required this.startDate,
    required this.endDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'] as String? ?? '',
      institution: json['institution'] as String? ?? '',
      specialite: json['specialite'] as String? ?? 'No specialty',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'specialite': specialite,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  Education copyWith({
    String? degree,
    String? institution,
    String? specialite,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Education(
      degree: degree ?? this.degree,
      institution: institution ?? this.institution,
      specialite: specialite ?? this.specialite,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class Skill {
  String name;
  int percentage;

  Skill({required this.name, required this.percentage});


  Skill copyWith({String? name, int? percentage}) {
    return Skill(
      name: name ?? this.name,
      percentage: percentage ?? this.percentage,
    );
  }


  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] as String? ?? '',
      percentage: json['percentage'] as int? ?? 0,
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
      jobTitle: json['jobTitle'] as String? ?? '',
      company: json['company'] as String? ?? '',
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

  Experience copyWith({
    String? jobTitle,
    String? company,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? responsibilities,
  }) {
    return Experience(
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      responsibilities: responsibilities ?? this.responsibilities,
    );
  }
}

