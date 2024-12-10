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
  File? _downloadedFile;
  File? get downloadedFile => _downloadedFile;
  List<AttachmentModel> _attachments = [];
  List<AttachmentModel> get attachments => _attachments;

  // Méthode pour uploader un fichier
  Future<void> uploadAttachment(String studentId, File file) async {
    _isUploading = true;
    notifyListeners();

    try {
      await _service.uploadAttachment(file, studentId);
      await fetchAttachments(studentId);
      _isUploading = false;
    } catch (e) {
      _errorMessage = 'Échec du téléchargement : ${e.toString()}';
      _isUploading = false;
    } finally {
      notifyListeners();
    }
  }

  // Méthode pour récupérer les pièces jointes
  Future<void> fetchAttachments(String studentId) async {
    _isUploading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Récupération des pièces jointes via le service
      _attachments = await _service.getAttachments(studentId);

      _isUploading = false;
      notifyListeners();
    } catch (e) {
      // Si l'appel échoue
      _errorMessage = 'Failed to fetch attachments: ${e.toString()}';
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAndSaveDocument(String filename) async {
    _isUploading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      _downloadedFile = await _service.viewAttachment(filename);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

}
