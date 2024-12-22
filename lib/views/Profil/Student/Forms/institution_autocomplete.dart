import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/services/institution_service.dart';
import 'package:frontend_app_stagi/viewmodels/institution_viewmodel.dart';
import 'package:provider/provider.dart';

class InstitutionAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final Key? key;

  InstitutionAutocomplete({
    required this.controller,
    required this.key,
  }) : super(key: key);

  @override
  _InstitutionAutocompleteState createState() => _InstitutionAutocompleteState();
}

class _InstitutionAutocompleteState extends State<InstitutionAutocomplete> {
  late InstitutionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = InstitutionViewModel(institutionService: InstitutionService());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InstitutionViewModel>.value(
      value: _viewModel,
      child: Consumer<InstitutionViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  labelText: 'Institution name',
                  labelStyle: const TextStyle(color: Color(0xFF3A6D8C)),
                  hintText: 'Enter your institution',
                  prefixIcon: Icon(Icons.business, color: Color(0xFF3A6D8C)),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  hintStyle: const TextStyle(color: Color(0xFF3A6D8C)),
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: viewModel.onSearchChanged,
              ),
              if (viewModel.isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CircularProgressIndicator(),
                ),
              if (viewModel.suggestions.isNotEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white, // Set background color to white
                    borderRadius: BorderRadius.circular(12), // Match with TextField
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: viewModel.suggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(viewModel.suggestions[index]),
                        onTap: () {
                          widget.controller.text = viewModel.suggestions[index];
                          viewModel.suggestions.clear(); // Clear suggestions after selection
                          // Optionally, call setState to update the UI
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
