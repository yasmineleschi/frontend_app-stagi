
import 'package:frontend_app_stagi/models/company.dart';
import 'package:frontend_app_stagi/services/company_service.dart';
import 'package:flutter/material.dart';

class CompanyProfileViewModel extends ChangeNotifier {
  Company? _companyProfile;
  bool _isLoading = false;
  String _errorMessage = '';
  List<Internship> _internships = [];
  List<Company> _filteredCompanies = [];
  final CompanyService _apiService = CompanyService();
  List<Company> get filteredCompanies => _filteredCompanies;
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



  Future<void> fetchFilteredCompanies({
    String? name,
    String? sector,
    String? address,
    String? internshipTitle,
    String? internshipDescription,
    String? internshipRequirements,

  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final companies = await _apiService.getFilteredCompanies(
        name: name,
        sector: sector,
        address: address,
        internshipTitle: internshipTitle,
        internshipDescription: internshipDescription,
        internshipRequirements: internshipRequirements,

      );

      if (companies is List<Company>) {
        _filteredCompanies = companies;
      } else {
        _errorMessage = 'Failed to load companies: Invalid data format.';
      }
    } catch (e) {
      _errorMessage = 'Error fetching companies: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}