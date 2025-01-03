import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Key? key;

  CustomDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF012E65)),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Text(item, style: const TextStyle(fontSize: 16)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
