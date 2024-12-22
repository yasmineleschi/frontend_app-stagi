import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetsCreateProfile/costum_widget_profile.dart';

class BasicInfoForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController sectorController;
  final TextEditingController phoneNumberController;
  final TextEditingController addressController;
  final TextEditingController websiteController;

  BasicInfoForm({
    required this.nameController,
    required this.sectorController,
    required this.phoneNumberController,
    required this.addressController,
    required this.websiteController,
  });

  static bool isValid(BuildContext context, {
    required TextEditingController nameController,
    required TextEditingController sectorController,
    required TextEditingController phoneNumberController,
    required TextEditingController addressController,
    required TextEditingController websiteController,
  }) {
    final name = nameController.text.trim();
    final sector = sectorController.text.trim();
    final phone = phoneNumberController.text.trim();
    final address = addressController.text.trim();
    final website = websiteController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company name is required')),
      );
      return false;
    }
    if (sector.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sector is required')),
      );
      return false;
    }
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number is required')),
      );
      return false;
    }
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address is required')),
      );
      return false;
    }
    if (website.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Website is required')),
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
        CustomTextField(
          key: const Key('usernameField'),
          controller: nameController,
          labelText: 'Company Name',
          icon: Icons.business_outlined,
          hintText: 'Enter the company name',
        ),
        const SizedBox(height: 15),
        CustomTextField(
          key: const Key('usernameField'),
          controller: sectorController,
          labelText: 'Sector',
          icon: Icons.work_outline,
          hintText: 'Enter the company sector',
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
                key: const Key('usernameField'),
                controller: phoneNumberController,
                labelText: 'Phone Number',
                icon: Icons.phone_outlined,
                hintText: 'Enter your phone number',
                isPhoneField: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        CustomTextField(
          key: const Key('usernameField'),
          controller: addressController,
          labelText: 'Company Address',
          icon: Icons.location_on_outlined,
          hintText: 'Enter the company address',
        ),
        const SizedBox(height: 15),
        CustomTextField(
          key: const Key('usernameField'),
          controller: websiteController,
          labelText: 'Website',
          icon: Icons.web_outlined,
          hintText: 'Enter the company website',
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
