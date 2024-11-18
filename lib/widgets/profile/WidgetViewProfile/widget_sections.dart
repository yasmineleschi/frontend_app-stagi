import 'package:flutter/material.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final Widget content;
  final IconData icon;
  final VoidCallback? hasAddIcon;
  final VoidCallback? onEditPressed;

  const ProfileSectionCard({
    Key? key,
    required this.title,
    required this.content,
    required this.icon,
    this.hasAddIcon,
    this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24, color: Colors.deepOrangeAccent),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (hasAddIcon != null)
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.deepOrangeAccent),
                      onPressed: hasAddIcon,
                    ),
                  if (onEditPressed != null)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: onEditPressed,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 8),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
