import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/models/studentProfile.dart';
import 'package:frontend_app_stagi/views/Profil/UpdateSections/UpdateBio.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetViewProfile/widget_about.dart';


class AboutSection extends StatelessWidget {
  final StudentProfile profile;
  final Function(String) onBioUpdated;

  const AboutSection({Key? key, required this.profile, required this.onBioUpdated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'About Me',
      content: '${profile.bio}',
      icon: Icons.account_box_outlined,
      onEditPressed: () {

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UpdateBioPage(
              initialBio: profile.bio ?? '',
              onBioUpdated: (newBio) {
                onBioUpdated(newBio);
              },
            ),
          ),
        );
      },
    );
  }
}
