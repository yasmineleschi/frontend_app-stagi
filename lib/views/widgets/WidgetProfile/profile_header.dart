import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  final profile;

  ProfileHeader({required this.profile});

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 80,
          backgroundImage: NetworkImage('https://www.fastweb.com/uploads/article_photo/photo/2036641/10-ways-to-be-a-better-student.jpeg'),
        ),
        const SizedBox(height: 10),
        Text(
          '${widget.profile.firstName} ${widget.profile.lastName}',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 5),
        Text(
          '${widget.profile.specialite}',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.blue, size: 16),
            const SizedBox(width: 4),
            Text(
              '${widget.profile.location}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          _isExpanded
              ? '${widget.profile.bio}'
              : '${widget.profile.bio.split(' ').take(10).join(' ')}...',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        if (widget.profile.bio.length > 10)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Read less' : 'Read more',
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
