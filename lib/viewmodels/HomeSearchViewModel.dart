import 'package:flutter/material.dart';

class HomeSearchViewModel extends ChangeNotifier {
  // All publications and companies
  List<dynamic> _allPublications = [];
  List<dynamic> _allCompanies = [];

  // Filtered data for each tab
  List<dynamic> _filteredPublications = [];
  List<dynamic> _filteredCompanies = [];

  // Public getters for filtered data
  List<dynamic> get filteredPublications => _filteredPublications;
  List<dynamic> get filteredCompanies => _filteredCompanies;

  /// Initialize data for publications and companies
  void initializeData({
    required List<dynamic> publications,
    required List<dynamic> companies,
  }) {
    _allPublications = publications ?? [];
    _allCompanies = companies ?? [];

    // Initially, show all data
    _filteredPublications = List.from(_allPublications);
    _filteredCompanies = List.from(_allCompanies);

    notifyListeners();
  }

  /// Filter publications based on the search query
  void filterPublications(String query) {
    if (query.isEmpty) {
      _filteredPublications = List.from(_allPublications);
    } else {
      _filteredPublications = _allPublications.where((publication) {
        final userName = (publication['user']?['username'] ?? '').toLowerCase();
        final content = (publication['content'] ?? '').toLowerCase();
        return userName.contains(query.toLowerCase()) ||
            content.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  /// Filter companies (internships) based on the search query
  void filterCompanies(String query) {
    if (query.isEmpty) {
      _filteredCompanies = List.from(_allCompanies);
    } else {
      _filteredCompanies = _allCompanies.where((company) {
        final companyName = company['companyName']?.toLowerCase() ?? '';
        final companyAddress = company['companyAddress']?.toLowerCase() ?? '';
        // You can add more fields to search based on your requirements
        return companyName.contains(query.toLowerCase()) ||
            companyAddress.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }


}
