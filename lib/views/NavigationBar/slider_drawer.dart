import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/views/ApplyNow/internship_application_view.dart';
import 'package:frontend_app_stagi/views/Home/Home_view.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Student_view.dart';
import 'package:frontend_app_stagi/views/Profil/Company/Company_view.dart';

class CustomDrawer extends StatelessWidget {
  final SidebarXController sidebarController;
  final String role;
  final String userId;
  final String token;
  final String companyId;

  const CustomDrawer({
    Key? key,
    required this.sidebarController,
    required this.role,
    required this.userId,
    required this.token,
    required this.companyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SidebarX(
        controller: sidebarController,
        theme: SidebarXTheme(
          decoration: BoxDecoration(color: Colors.white),
          textStyle: const TextStyle(color: Colors.black),
          selectedTextStyle: const TextStyle(color: Colors.black),
          selectedItemDecoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        extendedTheme: const SidebarXTheme(width: 200),
        items: [
          SidebarXItem(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(
                    role: role,
                    userId: userId,
                    token: token,
                  ),
                ),
              );
            },
          ),
          SidebarXItem(
            icon: Icons.account_box_outlined,
            label: 'Profile',
            onTap: () {
              if (role == 'Student') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentProfileView(userId: userId),
                  ),
                );
              } else if (role == 'Company') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompanyProfileView(userId: userId),
                  ),
                );
              }
            },
          ),
          if (role == 'Student') ...[
            SidebarXItem(
              icon: Icons.save_outlined,
              label: 'Internship Saved',
              onTap: () {
                print('Navigating to Saved Internships...');
              },
            ),
            SidebarXItem(
              icon: Icons.touch_app_outlined,
              label: 'Internship Applied',
              onTap: () {
                print('Navigating to Applied Internships...');
              },
            ),
          ],
          if (role == 'Company') ...[
            SidebarXItem(
              icon: Icons.verified_outlined,
              label: 'Confirm Internships',
              onTap: () {
                if (companyId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InternshipApplicationsPage(
                        companyId: companyId,
                      ),
                    ),
                  );
                } else {
                  print('Company ID is required to confirm internships');
                }
              },
            ),
          ],
          SidebarXItem(
            icon: Icons.logout,
            label: 'Logout',
            onTap: () {
              print('Logging out...');

            },
          ),
        ],
      ),
    );
  }
}
