class InternshipApplication {
  String? id;
  final String internshipId;
  final String studentId;
  final String message;
  final String? attachmentId;
  final String status;
  final DateTime appliedAt;
  final DateTime? interviewDate; // Ajout

  InternshipApplication({
    this.id,
    required this.internshipId,
    required this.studentId,
    required this.message,
    this.attachmentId,
    required this.status,
    required this.appliedAt,
    this.interviewDate, // Initialisation
  });

  factory InternshipApplication.fromJson(Map<String, dynamic> json) {
    return InternshipApplication(
      id: json['_id'] as String?,
      internshipId: json['internship']?['_id'] ?? '', // Assurez-vous que 'internship' existe
      studentId: json['studentId'] ?? '',
      message: json['message'] ?? '',
      attachmentId: json['attachment']?['_id'], // Vérifiez si attachmentId est un objet
      status: json['status'] ?? 'Pending',
      appliedAt: DateTime.parse(json['appliedAt']),
      interviewDate: json['interviewDate'] != null
          ? DateTime.parse(json['interviewDate'])
          : null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'internshipId': internshipId,
      'studentId': studentId,
      'message': message,
      'attachmentId': attachmentId,
      'status': status,
      'appliedAt': appliedAt.toIso8601String(),
      'interviewDate': interviewDate?.toIso8601String(), // Ajout à l’encodage
    };
  }
}
