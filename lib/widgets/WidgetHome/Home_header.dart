// lib/views/widgets/WidgetHome/home_header.dart
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onMenuTap;

  const HomeHeader({Key? key, required this.onMenuTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFF4267B2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Welcome to the Home Page',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
