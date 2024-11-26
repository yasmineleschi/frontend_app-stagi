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

  Future<void> addAttachment(String studentId, File file) async {
    _isUploading = true;
    notifyListeners();

    try {
      final attachment = await _service.uploadAttachment(studentId, file);

      if (attachment != null) {
        _attachments.add(attachment);
      } else {
        _errorMessage = 'Failed to upload attachment.';
      }
    } catch (e) {
      _errorMessage = 'Error during upload: $e';
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }


  Future<void> fetchAttachments(String studentId) async {
    _isUploading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _attachments = await _service.getAttachments(studentId);
    } catch (e) {
      _errorMessage = 'Failed to fetch attachments: $e';
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
