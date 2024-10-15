import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/services/student_api_service.dart';



class StudentProfileViewModel extends ChangeNotifier {
  StudentProfile? _studentProfile;
  bool _isLoading = false;
  String _errorMessage = '';

  final ApiService _apiService = ApiService();

  StudentProfile? get studentProfile => _studentProfile;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> getStudentProfile(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final profile = await _apiService.fetchStudentProfile(userId);

    if (profile != null) {
      _studentProfile = profile;
    } else {
      _errorMessage = 'Failed to load profile';
    }

    _isLoading = false;
    notifyListeners();
  }
  Future<bool> createStudentProfile(StudentProfile studentProfile, String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    studentProfile.userId = userId;

    final success = await _apiService.createStudentProfile(studentProfile);

    if (success) {
      _studentProfile = studentProfile;
    } else {
      _errorMessage = 'Failed to create profile';
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
