import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/services/institution_service.dart';


class InstitutionViewModel extends ChangeNotifier {
  final InstitutionService institutionService;
  List<String> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounce;

  InstitutionViewModel({required this.institutionService});

  List<String> get suggestions => _suggestions;
  bool get isLoading => _isLoading;

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _fetchInstitutions(query);
    });
  }

  Future<void> _fetchInstitutions(String query) async {
    if (query.isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _suggestions = await institutionService.fetchInstitutions(query);
    } catch (error) {
      print('Error: $error'); // Handle the error, e.g., show a Snackbar
      _suggestions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
