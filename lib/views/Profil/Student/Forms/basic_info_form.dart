import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';

class BasicInfoForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController specialityController;
  final TextEditingController bioController;
  final TextEditingController locationController;

  BasicInfoForm({
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.specialityController,
    required this.bioController,
    required this.locationController,
  });

  static bool isValid(BuildContext context, {
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController phoneController,
    required TextEditingController specialityController,
    required TextEditingController bioController,
    required TextEditingController locationController,
  }) {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();
    final speciality = specialityController.text.trim();
    final bio = bioController.text.trim();
    final location = locationController.text.trim();

    if (firstName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('First Name is required')),
      );
      return false;
    }
    if (lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Last Name is required')),
      );
      return false;
    }
    if (phone.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number must be at least 7 digits')),
      );
      return false;
    }
    if (speciality.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speciality is required')),
      );
      return false;
    }
    if (bio.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bio is required')),
      );
      return false;
    }
    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location is required')),
      );
      return false;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    String selectedCountryCode = '+216';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            Expanded(
              child: CustomTextField(
                key: const Key('firstNameField'),
                controller: firstNameController,
                labelText: 'First Name',
                icon: Icons.person_outline,
                hintText: 'First Name',
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: CustomTextField(
                key: const Key('lastNameField'),
                controller: lastNameController,
                labelText: 'Last Name',
                icon: Icons.person,
                hintText: 'Last Name',
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

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
                key: const Key('phoneField'),
                controller: phoneController,
                labelText: 'Phone',
                icon: Icons.phone,
                hintText: 'Enter your phone number',
                isPhoneField: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        CustomTextField(
          key: const Key('specialityField'),
          controller: specialityController,
          labelText: 'Speciality',
          icon: Icons.work_outline,
          hintText: 'Enter your speciality',
        ),
        const SizedBox(height: 15),

        CustomTextField(
          key: const Key('locationField'),
          controller: locationController,
          labelText: 'Location',
          icon: Icons.location_on,
          hintText: 'Enter your location',
        ),
        const SizedBox(height: 15),

        CustomTextField(
          key: const Key('bioField'),
          controller: bioController,
          labelText: 'Bio',
          icon: Icons.info_outline,
          hintText: 'Tell us about yourself',
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
