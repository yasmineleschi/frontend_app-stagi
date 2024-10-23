import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/services/student_service.dart';

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

  Future<bool> createStudentProfile(
      StudentProfile studentProfile, String userId) async {
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

  Future<void> updateBio(String userId, String newBio) async {
    if (_studentProfile == null) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {

      StudentProfile updatedProfile = _studentProfile!.copyWith(bio: newBio);
      final bool isSuccess = await _apiService.updateStudentProfile(userId, updatedProfile);

      if (isSuccess) {
        _studentProfile!.bio = newBio;
      } else {
        _errorMessage = 'Failed to update bio. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred while updating bio: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> updateProfileInfo(
      String userId,
      String newFirstName,
      String newLastName,
      String newPhone,
      String newSpeciality,
      String newLocation) async {

    if (_studentProfile == null) {
      _errorMessage = 'Profile not found';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {

      StudentProfile updatedProfile = _studentProfile!.copyWith(
        firstName: newFirstName,
        lastName: newLastName,
        phone: newPhone,
        specialite: newSpeciality,
        location: newLocation,
      );

      final bool isSuccess = await _apiService.updateStudentProfile(userId, updatedProfile);

      if (isSuccess) {

        _studentProfile = updatedProfile;
      } else {
        _errorMessage = 'Failed to update profile. Please try again.';
      }
    } catch (e) {

      _errorMessage = 'An error occurred while updating profile: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSkill(String userId, Skill updatedSkill) async {
    if (_studentProfile == null) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {

      List<Skill> updatedSkills = List.from(_studentProfile!.skills);
      int skillIndex = updatedSkills.indexWhere((skill) => skill.name == updatedSkill.name);

      if (skillIndex != -1) {
        updatedSkills[skillIndex] = updatedSkill;

        StudentProfile updatedProfile = _studentProfile!.copyWith(skills: updatedSkills);
        final bool isSuccess = await _apiService.updateStudentProfile(userId, updatedProfile);

        if (isSuccess) {
          _studentProfile!.skills[skillIndex] = updatedSkill;
        } else {
          _errorMessage = 'Failed to update skill. Please try again.';
        }
      }
    } catch (e) {
      _errorMessage = 'An error occurred while updating the skill: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> updateEducation(String userId, Education updatedEducation) async {
    if (_studentProfile == null) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      List<Education> updatedEducationList = List.from(_studentProfile!.education);
      int educationIndex = updatedEducationList.indexWhere((edu) => edu.degree == updatedEducation.degree && edu.institution == updatedEducation.institution);

      if (educationIndex != -1) {
        updatedEducationList[educationIndex] = updatedEducation;

        StudentProfile updatedProfile = _studentProfile!.copyWith(education: updatedEducationList);
        final bool isSuccess = await _apiService.updateStudentProfile(userId, updatedProfile);

        if (isSuccess) {
          _studentProfile!.education[educationIndex] = updatedEducation;
        } else {
          _errorMessage = 'Failed to update education. Please try again.';
        }
      }
    } catch (e) {
      _errorMessage = 'An error occurred while updating the education: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> updateExperience(String userId, Experience updatedExperience) async {
    if (_studentProfile == null) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      List<Experience> updatedExperienceList = List.from(_studentProfile!.experience);
      int experienceIndex = updatedExperienceList.indexWhere((exp) => exp.jobTitle == updatedExperience.jobTitle && exp.company == updatedExperience.company);

      if (experienceIndex != -1) {
        updatedExperienceList[experienceIndex] = updatedExperience;

        StudentProfile updatedProfile = _studentProfile!.copyWith(experience: updatedExperienceList);
        final bool isSuccess = await _apiService.updateStudentProfile(userId, updatedProfile);

        if (isSuccess) {
          _studentProfile!.experience[experienceIndex] = updatedExperience;
        } else {
          _errorMessage = 'Failed to update experience. Please try again.';
        }
      }
    } catch (e) {
      _errorMessage = 'An error occurred while updating the experience: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }




}
