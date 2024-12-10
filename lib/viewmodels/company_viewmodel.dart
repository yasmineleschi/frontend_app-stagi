
import 'package:frontend_app_stagi/models/company.dart';
import 'package:frontend_app_stagi/services/company_service.dart';
import 'package:flutter/material.dart';

class CompanyProfileViewModel extends ChangeNotifier {
  Company? _companyProfile;
  bool _isLoading = false;
  String _errorMessage = '';
  List<Internship> _internships = [];

  final CompanyService _apiService = CompanyService();

  Company? get company => _companyProfile;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Internship> get internships => _internships;

  Future<void> fetchInternships() async {
    _isLoading = true;
    notifyListeners();

    try {

      final fetchedInternships = await _apiService.fetchInternships();


      if (fetchedInternships is List<Internship>) {
        _internships.clear();
        _internships.addAll(fetchedInternships);
      } else {
        _errorMessage = 'Failed to load internships: Invalid data format';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCompanyProfile(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final profile = await _apiService.fetchCompanyProfile(userId);
      if (profile != null) {
        _companyProfile = profile;
      } else {
        _errorMessage = 'Failed to load profile';
      }
    } catch (e) {
      _errorMessage = 'Error loading profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCompanyProfile(Company profile, String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    profile.userId = profile.userId;

    bool success = await _apiService.createCompanyProfile(profile);

    if (success) {
      _companyProfile = profile;
      _errorMessage = '';
    } else {
      _errorMessage = 'Failed to create profile';
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> updateInternship(String userId, Internship updatedInternship) async {
    if (_companyProfile == null) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      List<Internship> updatedInternships = List.from(_companyProfile!.internships);
      int InternshipIndex =
      updatedInternships.indexWhere((internship) => internship.id == updatedInternship.id);

      if (InternshipIndex != -1) {
        updatedInternships[InternshipIndex] = updatedInternship;

        Company updatedProfile =
        _companyProfile!.copyWith(internships: updatedInternships);
        final bool isSuccess =
        await _apiService.updateCompanyProfile(userId, updatedProfile);

        if (isSuccess) {
          _companyProfile!.internships[InternshipIndex] = updatedInternship;
        } else {
          _errorMessage = 'Failed to update internship . Please try again.';
        }
      }
    } catch (e) {
      _errorMessage = 'An error occurred while updating the internship: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? newDescription,
    String? newSector,
    String? newPhoneNumber,
    DateTime? newYearFounded,
    String? newEmployeeCount,
    String? newWebsite}) async {

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {

      Company updatedProfile = _companyProfile!.copyWith(
        description: newDescription,
        sector: newSector,
        phoneNumber: newPhoneNumber,
        yearFounded: newYearFounded,
        employeeCount: newEmployeeCount,
        website: newWebsite,
      );


      final bool isSuccess = await _apiService.updateCompanyProfile(userId, updatedProfile);

      if (isSuccess) {
        _companyProfile = updatedProfile;
      } else {
        _errorMessage = 'Failed to update the profile. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred while updating the profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


// Future<bool> deleteInternship(String internshipId) async {
//   if (_companyProfile == null) return false; // Check if company profile exists
//
//   _isLoading = true;
//   _errorMessage = '';
//   notifyListeners();
//
//   try {
//     // Find the companyId from the current company profile
//     String companyId = _companyProfile!.id ?? '';
//
//     // Remove the internship from the list
//     List<Internship> updatedInternships = List.from(_companyProfile!.internships);
//     updatedInternships.removeWhere((internship) => internship.id == internshipId);
//
//     // Call the API to delete the internship
//     final bool isSuccess = await _apiService.deleteInternship(companyId, internshipId);
//
//     if (isSuccess) {
//       // Update the company profile with the updated internships list
//       _companyProfile = _companyProfile!.copyWith(internships: updatedInternships);
//       _errorMessage = ''; // Clear any error messages
//     } else {
//       _errorMessage = 'Failed to delete internship'; // Set an error message if the API fails
//     }
//   } catch (e) {
//     _errorMessage = 'An error occurred while deleting the internship: $e'; // Catch and handle any errors
//   } finally {
//     _isLoading = false; // Set loading state to false
//     notifyListeners(); // Notify listeners to update the UI
//   }
//
//   return _errorMessage.isEmpty; // Return true if deletion was successful, false otherwise
// }
}