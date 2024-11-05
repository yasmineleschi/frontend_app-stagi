import 'package:flutter/material.dart';

class HomeSearchViewModel extends ChangeNotifier {
  List<dynamic> _allPublications = [];
  List<dynamic> filteredPublications = [];

  void initializePublications(List<dynamic> publications) {
    _allPublications = publications;
    filteredPublications = publications;
    notifyListeners();
  }

  void filterPublications(String query) {
    if (query.isEmpty) {
      filteredPublications = _allPublications;
    } else {
      filteredPublications = _allPublications.where((publication) {
        final userName = publication['user']['username']?.toLowerCase() ?? '';
        return userName.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
