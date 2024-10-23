import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final Function(String?)? onChanged;
  final String hintText;

  CustomDropdownField({
    required this.labelText,
    required this.icon,
    required this.items,
    this.value,
    this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF3A6D8C)),
          prefixIcon: Icon(icon, color: Color(0xFF3A6D8C)),
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
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF3A6D8C)),
        ),
        items: items,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF3A6D8C)),
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
