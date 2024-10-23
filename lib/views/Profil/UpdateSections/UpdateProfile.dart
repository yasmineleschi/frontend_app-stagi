import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/ConfirmationBottomSheet.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsUpdateProfile/CustomTextField_update.dart';
import 'package:country_code_picker/country_code_picker.dart';

class UpdateProfilePage extends StatelessWidget {
  final String initialFirstName;
  final String initialLastName;
  final String initialPhone;
  final String initialSpeciality;
  final String initialLocation;
  final Function(String, String, String, String, String) onProfileUpdated;

  const UpdateProfilePage({
    Key? key,
    required this.initialFirstName,
    required this.initialLastName,
    required this.initialPhone,
    required this.initialSpeciality,
    required this.initialLocation,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String newFirstName = initialFirstName;
    String newLastName = initialLastName;
    String newPhone = initialPhone;
    String newSpeciality = initialSpeciality;
    String newLocation = initialLocation;
    String selectedCountryCode = '+216';

    return WillPopScope(
        onWillPop: () async {
      _showConfirmationBottomSheet(context);
      return false;
    },
    child: Scaffold(
      backgroundColor: const Color(0xFFF5F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F2F2),
      ),
      body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change Profile Info ',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Roboto Slab',
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF3A6D8C),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel('First Name'),
                CustomTextField(
                  labelText: '',
                  initialValue: initialFirstName,
                  onChanged: (value) {
                    newFirstName = value;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Last Name'),
                CustomTextField(
                  labelText: '',
                  initialValue: initialLastName,
                  onChanged: (value) {
                    newLastName = value;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Phone number'),
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
                        labelText: '',
                        initialValue: initialPhone,
                        onChanged: (value) {
                          newPhone = value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabel('Speciality'),
                CustomTextField(
                  labelText: '',
                  initialValue: initialSpeciality,
                  onChanged: (value) {
                    newSpeciality = value;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Location'),
                CustomTextField(
                  labelText: '',
                  initialValue: initialLocation,
                  onChanged: (value) {
                    newLocation = value;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        onProfileUpdated(
                          newFirstName,
                          newLastName,
                          '$selectedCountryCode $newPhone',
                          newSpeciality,
                          newLocation,
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

          },
          onUndo: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: 'Roboto Slab',
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
    );
  }
}
