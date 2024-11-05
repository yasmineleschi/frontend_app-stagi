import 'package:flutter/material.dart';

class LabeledText extends StatelessWidget {
  final String label;

  const LabeledText({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'Roboto Slab',

          color: Color(0xFF012E65),
        ),
      ),
    );
  }
}
