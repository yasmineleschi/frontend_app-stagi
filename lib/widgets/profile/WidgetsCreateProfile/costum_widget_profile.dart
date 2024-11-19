import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final String hintText;
  final bool isReadOnly;
  final bool isPhoneField;
  final GestureTapCallback? onTap;
  final Function(String)? onChanged;
  final int? maxLines;

  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.hintText,
    this.isReadOnly = false,
    this.isPhoneField = false,
    this.onTap,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isReadOnly ? onTap : null,
      child: AbsorbPointer(
        absorbing: isReadOnly,
        child: Container(
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
          child: TextFormField(
            controller: controller,
            readOnly: isReadOnly,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(color: Color(0xFF3A6D8C)),
              hintText: hintText,
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
              hintStyle: const TextStyle(color: Color(0xFF3A6D8C)),
            ),
            style: const TextStyle(color: Colors.black),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
