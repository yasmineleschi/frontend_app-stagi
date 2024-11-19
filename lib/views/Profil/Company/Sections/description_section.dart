import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/views/Profil/Company/updateSection/update_profile_campany.dart';
import 'package:frontend_app_stagi/widgets/profile/WidgetViewProfile/widget_sections.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionSection extends StatefulWidget {
  final dynamic companyProfile;

  const DescriptionSection({Key? key, required this.companyProfile}) : super(key: key);

  @override
  _DescriptionSectionState createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'About Us',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${widget.companyProfile.description}\n',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontFamily: "Roboto Slab",
                    fontSize: 16,
                  ),
                ),
                const TextSpan(text: '\n'), // Extra spacing
                const TextSpan(
                  text: 'Sector \n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto Slab", fontSize: 16),
                ),
                TextSpan(
                  text: '${widget.companyProfile.sector}\n',
                  style: const TextStyle(fontWeight: FontWeight.w300, fontFamily: "Roboto Slab", fontSize: 14),
                ),
                const TextSpan(text: '\n'), // Extra spacing
                const TextSpan(
                  text: 'Website \n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto Slab", fontSize: 16),
                ),
                TextSpan(
                  text: '${widget.companyProfile.website}\n',
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w300,
                    fontFamily: "Roboto Slab",
                    fontSize: 14,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () => _launchURL(widget.companyProfile.website),
                ),
                const TextSpan(text: '\n'), // Extra spacing
                const TextSpan(
                  text: 'Company Size \n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto Slab", fontSize: 16),
                ),
                TextSpan(
                  text: '${widget.companyProfile.employeeCount} employees\n',
                  style: const TextStyle(fontWeight: FontWeight.w300, fontFamily: "Roboto Slab", fontSize: 16),
                ),
                const TextSpan(text: '\n'), // Extra spacing
                const TextSpan(
                  text: 'Year Founded \n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto Slab", fontSize: 16),
                ),
                TextSpan(
                  text: '${widget.companyProfile.yearFounded.year}\n',
                  style: const TextStyle(fontWeight: FontWeight.w300, fontFamily: "Roboto Slab", fontSize: 14),
                ),
                const TextSpan(text: '\n'), // Extra spacing
                const TextSpan(
                  text: 'Contact Us \n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto Slab", fontSize: 16),
                ),
                TextSpan(
                  text: '${widget.companyProfile.phoneNumber}\n ',
                  style: const TextStyle(fontWeight: FontWeight.w300, fontFamily: "Roboto Slab", fontSize: 14),
                ),
                const TextSpan(text: '\n'), // Extra spacing
              ],
            ),
          ),
        ],
      ),
      icon: Icons.account_box_outlined,
      // onEditPressed: () {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (context) => EditAboutUsPage(
      //         initialDescription: widget.companyProfile.description,
      //         initialSector: widget.companyProfile.sector,
      //         initialWebsite: widget.companyProfile.website,
      //         initialEmployeCount: widget.companyProfile.employeeCount,
      //         initialYearFounded: widget.companyProfile.yearFounded,
      //         initialPhone: widget.companyProfile.phoneNumber,
      //         onProfileUpdated: (description, sector, website, employeeCount, yearFounded, phone) {
      //           setState(() {
      //             widget.companyProfile.description = description;
      //             widget.companyProfile.sector = sector;
      //             widget.companyProfile.website = website;
      //             widget.companyProfile.employeeCount = employeeCount;
      //             widget.companyProfile.yearFounded = yearFounded;
      //             widget.companyProfile.phoneNumber = phone;
      //           });
      //         },
      //       ),
      //     ),
      //   );
      // },
    );
  }
}
