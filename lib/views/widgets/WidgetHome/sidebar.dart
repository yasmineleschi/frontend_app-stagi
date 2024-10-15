// lib/views/Home/sidebar.dart
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final VoidCallback onClose; // Function to close the sidebar

  const Sidebar({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 250,
      color: Color(0xFF4267B2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            child: Text(
              'Sidebar Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: onClose, // Close the sidebar when an item is tapped
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: onClose,
          ),
        ],
      ),
    );
  }
}
