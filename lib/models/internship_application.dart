class InternshipApplication {
  String? id;
  final String internshipId;
  final String internshipTitle; // Nouveau champ ajouté
  final String studentId;
  final String message;
  final String? attachmentId;
  final String status;
  final DateTime appliedAt;
  final DateTime? interviewDate;

  InternshipApplication({
    this.id,
    required this.internshipId,
    required this.internshipTitle, // Initialisation du champ
    required this.studentId,
    required this.message,
    this.attachmentId,
    required this.status,
    required this.appliedAt,
    this.interviewDate,
  });

  factory InternshipApplication.fromJson(Map<String, dynamic> json) {
    return InternshipApplication(
      id: json['_id'] as String?,
      internshipId: json['internshipId'] is Map<String, dynamic>
          ? json['internshipId']['_id'] ?? ''
          : json['internshipId'] ?? '',
      internshipTitle: json['internshipTitle'] ?? '', // Récupération du champ
      studentId: json['studentId'] is Map<String, dynamic>
          ? json['studentId']['_id'] ?? ''
          : json['studentId'] ?? '',
      message: json['message'] ?? '',
      attachmentId: json['attachmentId'] is Map<String, dynamic>
          ? json['attachmentId']['_id']
          : json['attachmentId'],
      status: json['status'] ?? 'Pending',
      appliedAt: json['appliedAt'] != null
          ? DateTime.parse(json['appliedAt'])
          : DateTime.now(),
      interviewDate: json['interviewDate'] != null
          ? DateTime.parse(json['interviewDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'internshipId': internshipId,
      'internshipTitle': internshipTitle,
      'studentId': studentId,
      'message': message,
      'attachmentId': attachmentId,
      'status': status,
      'appliedAt': appliedAt.toIso8601String(),
      'interviewDate': interviewDate?.toIso8601String(),
    };
  }
}
