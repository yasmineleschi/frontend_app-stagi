import 'package:flutter/foundation.dart';
import '../models/internship_application.dart';
import '../services/internship_service.dart';

class InternshipViewModel with ChangeNotifier {
  final InternshipService _service = InternshipService();
  List<InternshipApplication> _applications = [];
  bool _isLoading = false;
  String? errorMessage;
  List<InternshipApplication> get applications => _applications;
  bool get isLoading => _isLoading;

  Future<void> applyForInternship({
    required String internshipId,
    required String studentId,
    required String message,
    String? attachmentId,
    String? internshipTitle,
  }) async {
    print('Applying for internship with the following details:');
    print('Internship ID: $internshipId');
    print('Student ID: $studentId');
    print('Message: $message');
    print('Attachment ID: ${attachmentId ?? "No attachment provided"}');
    print('Internship Title: ${internshipTitle ?? "No title provided"}');

    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    final success = await _service.applyForInternship(
      internshipId: internshipId,
      studentId: studentId,
      message: message,
      attachmentId: attachmentId,
      internshipTitle: internshipTitle,
    );

    if (!success) {
      errorMessage = "Failed to apply for the internship.";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchApplications(String companyId) async {
    try {
      _isLoading = true;
      notifyListeners();
      _applications = await _service.getCompanyApplications(companyId);
    } catch (e) {
      _applications = [];
      debugPrint("Error fetching applications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> fetchApplicationsForStudent(String studentId) async {
    try {
      _isLoading = true;
      notifyListeners();
      _applications = await _service.getStudentApplications(studentId);
    } catch (e) {
      debugPrint("Error fetching applications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> updateApplicationStatus(
      String applicationId,
      String status, {
        DateTime? interviewDate,
      }) async {
    try {
      _isLoading = true;
      notifyListeners();


      final success = await _service.updateApplicationStatus(
        applicationId,
        status,
        interviewDate: interviewDate,
      );

      if (success) {
        final index =
        _applications.indexWhere((app) => app.id == applicationId);
        if (index != -1) {
          _applications[index] = InternshipApplication(
            id: _applications[index].id,
            internshipId: _applications[index].internshipId,
            internshipTitle: _applications[index].internshipTitle,
            studentId: _applications[index].studentId,
            message: _applications[index].message,
            attachmentId: _applications[index].attachmentId,
            status: status,
            appliedAt: _applications[index].appliedAt,
            interviewDate: interviewDate,
          );
        }
      }
    } catch (e) {
      throw Exception("Failed to update application status: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
