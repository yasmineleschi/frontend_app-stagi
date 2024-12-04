import 'package:frontend_app_stagi/models/company.dart';
import 'package:frontend_app_stagi/services/company_service.dart';
import 'package:flutter/material.dart';

class CompanyProfileViewModel extends ChangeNotifier {
  Company? _companyProfile;
  bool _isLoading = false;
  String _errorMessage = '';
  List<Internship> _internships = [];
  List<Internship> _filteredInternships = [];
  final CompanyService _apiService = CompanyService();

  List<Internship> get internships => _filteredInternships;
  Company? get company => _companyProfile;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch internships from the API
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

  // Filter internships based on search query
  void filterInternships(String query) {
    if (query.isEmpty) {
      _filteredInternships = _internships;
    } else {
      _filteredInternships = _internships
          .where((internship) =>
          internship.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Get company profile by userId
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

  // Create company profile
  Future<bool> createCompanyProfile(Company profile, String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    profile.userId = userId; // Correct userId assignment

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

  // Update internship details
  Future<void> updateInternship(String userId, Internship updatedInternship) async {
    if (_companyProfile == null) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      List<Internship> updatedInternships = _companyProfile!.internships ?? [];
      int internshipIndex = updatedInternships.indexWhere((internship) =>
      internship.id == updatedInternship.id);

      if (internshipIndex != -1) {
        updatedInternships[internshipIndex] = updatedInternship;

        Company updatedProfile =
        _companyProfile!.copyWith(internships: updatedInternships);
        final bool isSuccess =
        await _apiService.updateCompanyProfile(userId, updatedProfile);

        if (isSuccess) {
          _companyProfile!.internships[internshipIndex] = updatedInternship;
        } else {
          _errorMessage = 'Failed to update internship. Please try again.';
        }
      }
    } catch (e) {
      _errorMessage = 'An error occurred while updating the internship: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update company profile information
  Future<void> updateProfile({
    required String userId,
    String? newDescription,
    String? newSector,
    String? newPhoneNumber,
    DateTime? newYearFounded,
    String? newEmployeeCount,
    String? newWebsite,
  }) async {
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
}
