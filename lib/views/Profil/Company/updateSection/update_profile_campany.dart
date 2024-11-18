import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/ConfirmationBottomSheet.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/CustomTextField_update.dart';
import 'package:country_code_picker/country_code_picker.dart';

class EditAboutUsPage extends StatelessWidget {
  final String initialDescription;
  final String initialSector;
  final String initialWebsite;
  final String initialEmployeCount;
  final DateTime initialYearFounded;
  final String initialPhone;
  final Function(String, String, String, String, DateTime, String) onProfileUpdated;

  const EditAboutUsPage({
    Key? key,
    required this.initialDescription,
    required this.initialSector,
    required this.initialWebsite,
    required this.initialEmployeCount,
    required this.initialYearFounded,
    required this.initialPhone,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String newDescription = initialDescription;
    String newSector = initialSector;
    String newWebsite = initialWebsite;
    String newEmployeCount = initialEmployeCount;
    DateTime newYearFounded = initialYearFounded;
    String newPhoneNumber = initialPhone;
    String selectedCountryCode = '+216';

    return WillPopScope(
      onWillPop: () async {
        _showConfirmationBottomSheet(context);
        return false; // Bloque le retour pour confirmer.
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F2F2),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F2F2),
          title: const Text("Edit About Us", style: TextStyle(color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change Profile Info',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Roboto Slab',
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF3A6D8C),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('Description Your Company'),
                CustomTextField(
                  labelText: 'Company Description',
                  initialValue: initialDescription,
                  onChanged: (value) {
                    newDescription = value;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Sector'),
                CustomTextField(
                  labelText: 'Company Sector',
                  initialValue: initialSector,
                  onChanged: (value) {
                    newSector = value;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Phone Number'),
                Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (countryCode) {
                        selectedCountryCode = countryCode.dialCode!;
                      },
                      initialSelection: 'TN',
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      favorite: ['+216', 'FR'],
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Phone Number',
                        initialValue: initialPhone,
                        onChanged: (value) {
                          newPhoneNumber = value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabel('Website'),
                CustomTextField(
                  labelText: 'Company Website',
                  initialValue: initialWebsite,
                  onChanged: (value) {
                    newWebsite = value;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Company Size'),
                CustomTextField(
                  labelText: 'Employee Count',
                  initialValue: initialEmployeCount,
                  onChanged: (value) {
                    newEmployeCount = value;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Year Founded'),
                CustomTextField(
                  labelText: 'Year Founded',
                  initialValue: initialYearFounded.toIso8601String(),
                  onChanged: (value) {
                    newYearFounded = DateTime.tryParse(value) ?? initialYearFounded;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        onProfileUpdated(
                          newDescription,
                          newSector,
                          newWebsite,
                          newEmployeCount,
                          newYearFounded,
                          newPhoneNumber,
                        );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A6D8C),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationBottomSheet(
          title: 'Undo Changes?',
          message: 'Are you sure you want to discard the changes made?',
          onContinue: () {
            Navigator.of(context).pop(); // Retour en arrière
          },
          onUndo: () {
            Navigator.of(context).pop(); // Fermer la feuille
          },
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Roboto Slab',
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      ),
    );
  }
}
