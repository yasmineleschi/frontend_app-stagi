import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? initialValue;
  final Function(String) onChanged;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.onChanged,
    this.initialValue,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        child: TextField(
          onChanged: onChanged,
          controller: TextEditingController(text: initialValue),
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Color(0xFF3A6D8C)),
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
        ),
      ),
    );
  }
}
