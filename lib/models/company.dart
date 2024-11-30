class Company {
  String? userId;
  String name;
  String sector;
  String address;
  String phoneNumber;
  String website;
  String description;
  DateTime yearFounded;
  String employeeCount;
  List<Internship> internships;

  Company({
    this.userId,
    required this.name,
    required this.sector,
    required this.address,
    required this.phoneNumber,
    required this.website,
    required this.description,
    required this.yearFounded,
    required this.employeeCount,
    required this.internships,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      userId: json['userId'] as String?,
      name: json['name'] ?? 'Nom inconnu',
      sector: json['sector'] ?? 'Secteur inconnu',
      address: json['address'] ?? 'Adresse inconnue',
      phoneNumber: json['phoneNumber'] ?? 'Numéro inconnu',
      website: json['website'] ?? 'Site web inconnu',
      description: json['description'] ?? 'Pas de description fournie',
      yearFounded: DateTime.parse(json['yearFounded'] ?? DateTime.now().toIso8601String()),
      employeeCount: json['employeeCount'] ?? '0',
      internships: (json['internships'] as List<dynamic>? ?? [])
          .map((internship) => Internship.fromJson(internship as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'sector': sector,
      'address': address,
      'phoneNumber': phoneNumber,
      'website': website,
      'description': description,
      'yearFounded': yearFounded.toIso8601String(),
      'employeeCount': employeeCount,
      'internships': internships.map((internship) => internship.toJson()).toList(),
    };
  }

  Company copyWith({
    String? userId,
    String? name,
    String? sector,
    String? address,
    String? phoneNumber,
    String? website,
    String? description,
    DateTime? yearFounded,
    String? employeeCount,
    List<Internship>? internships,
  }) {
    return Company(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      sector: sector ?? this.sector,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      description: description ?? this.description,
      yearFounded: yearFounded ?? this.yearFounded,
      employeeCount: employeeCount ?? this.employeeCount,
      internships: internships ?? this.internships,
    );
  }
}


class Internship {
  String? id;
  final String title;
  final String description;
  final List<String> requirements;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime postedDate;
  final bool isActive;
  final String companyName;
  final String companyAddress;
  String? companyId;

  Internship({
    this.id,
    required this.title,
    required this.description,
    required this.requirements,
    required this.startDate,
    required this.endDate,
    required this.postedDate,
    required this.isActive,
    required this.companyName,
    required this.companyAddress,
    this.companyId,
  });

  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      postedDate: DateTime.parse(json['postedDate'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? false,
      companyName: json['companyName'] ?? 'Unknown Company',
      companyAddress: json['companyAddress'] ?? 'Unknown Company',
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'requirements': requirements,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'postedDate': postedDate.toIso8601String(),
      'isActive': isActive,
      'companyId': companyId,
    };
  }


  Internship copyWith({
    String? title,
    String? description,
    List<String>? requirements,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? postedDate,
    bool? isActive,
    String? companyName,
    String? companyAddress,
    String? companyId,
  }) {
    return Internship(
      title: title ?? this.title,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      postedDate: postedDate ?? this.postedDate,
      isActive: isActive ?? this.isActive,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      companyId: companyId ?? this.companyId,

    );
  }
}




