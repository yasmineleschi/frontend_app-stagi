class InternshipApplication {
  String? id;
  final String internshipId;
  final String studentId;
  final String message;
  final String? attachmentId;
  final String status;
  final DateTime appliedAt;

  InternshipApplication({
    this.id,
    required this.internshipId,
    required this.studentId,
    required this.message,
    this.attachmentId,
    required this.status,
    required this.appliedAt,
  });

  factory InternshipApplication.fromJson(Map<String, dynamic> json) {
    return InternshipApplication(
      id: json['_id'] as String?,
      internshipId: json['internshipId'] is Map<String, dynamic>
          ? json['internshipId']['_id'] ?? ''
          : json['internshipId'] ?? '',
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
    };
  }
}
