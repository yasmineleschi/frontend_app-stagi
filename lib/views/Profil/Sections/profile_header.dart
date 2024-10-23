import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/views/Profil/UpdateSections/UpdateProfile.dart';

class ProfileHeader extends StatefulWidget {
  final dynamic profile;

  const ProfileHeader({Key? key, required this.profile}) : super(key: key);

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  void _navigateToUpdateProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateProfilePage(
          initialFirstName: widget.profile.firstName,
          initialLastName: widget.profile.lastName,
          initialPhone: widget.profile.phone,
          initialSpeciality: widget.profile.specialite,
          initialLocation: widget.profile.location,
          onProfileUpdated: (firstName, lastName, phone, speciality, location) {
            setState(() {
              widget.profile.firstName = firstName;
              widget.profile.lastName = lastName;
              widget.profile.phone = phone;
              widget.profile.specialite = speciality;
              widget.profile.location = location;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            image: DecorationImage(
              image: AssetImage('assets/img_1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            'https://www.fastweb.com/uploads/article_photo/photo/2036641/10-ways-to-be-a-better-student.jpeg', // Profile image
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.profile.firstName} ${widget.profile.lastName}', // Full name
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.profile.specialite, // Speciality
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.white70, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.profile.location, // Location
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 16,
                  child: OutlinedButton.icon(
                    onPressed: _navigateToUpdateProfile,
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text('Edit profile', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
