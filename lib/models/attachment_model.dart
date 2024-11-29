class AttachmentModel {
  final String id;
  final String studentId;
  final String fileName;
  final String filePath;
  final String fileType;
  final DateTime uploadedAt;


  AttachmentModel({
    required this.id,
    required this.studentId,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.uploadedAt,
  });


  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['_id'],
      studentId: json['studentId'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      fileType: json['fileType'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studentId': studentId,
      'fileName': fileName,
      'filePath': filePath,
      'fileType': fileType,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}
