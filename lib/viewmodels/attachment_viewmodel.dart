import 'dart:io';
import 'package:flutter/material.dart';
import '../models/attachment_model.dart';
import '../services/attachment_service.dart';

class AttachmentViewModel extends ChangeNotifier {
  final AttachmentService _service = AttachmentService();

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<AttachmentModel> _attachments = [];
  List<AttachmentModel> get attachments => _attachments;


  Future<AttachmentModel?> uploadAttachment(String studentId, File file) async {
    _isUploading = true;
    notifyListeners();

    try {
      final uploadedAttachment = await _service.uploadAttachment(file, studentId);

      if (uploadedAttachment != null) {
        _attachments.add(uploadedAttachment);
        notifyListeners();
      }

      _isUploading = false;
      return uploadedAttachment;
    } catch (e) {
      _errorMessage = 'Upload failed: ${e.toString()}';
      _isUploading = false;
      notifyListeners();
      return null;
    }
  }


  Future<void> fetchAttachments(String studentId) async {
    _isUploading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _attachments = await _service.getAttachments(studentId);
      _isUploading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch attachments: $e';
      _isUploading = false;
      notifyListeners();
    }
  }
}
