import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/student_viewmodel.dart';
import 'package:frontend_app_stagi/views/ApplyNow/internship_application_view.dart';
import 'package:frontend_app_stagi/views/ApplyNow/internship_student.dart';
import 'package:frontend_app_stagi/views/Home/Home_view.dart';
import 'package:frontend_app_stagi/views/Profil/Company/Company_view.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Student_view.dart';
import 'package:frontend_app_stagi/views/authentification/signin_view.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

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
      backgroundColor: Colors.transparent,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color(0xFF1B3B6D),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/photoprofile.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome, ${role == 'Student' ? 'Student' : 'Company'}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SidebarX(
              controller: sidebarController,
              extendedTheme: const SidebarXTheme(
                width: 250,
              ),
              theme: SidebarXTheme(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                textStyle: const TextStyle(color: Colors.black),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                selectedItemDecoration: BoxDecoration(
                  color: const Color(0xFF1B3B6D),
                  borderRadius: BorderRadius.circular(8),
                ),
                itemPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                iconTheme: const IconThemeData(size: 20, color: Colors.black54),
                selectedIconTheme: const IconThemeData(size: 22, color: Colors.white),
              ),
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
                  icon: Icons.account_circle_outlined,
                  label: 'Profile',
                  onTap: () {
                    if (role == 'Student') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentProfileView(userId: userId),
                        ),
                      );
                    } else {
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
                    icon: Icons.bookmark_border_outlined,
                    label: 'Saved Internships',
                    onTap: () {
                      // Navigation for saved internships
                    },
                  ),
                  SidebarXItem(
                    icon: Icons.check_circle_outline,
                    label: 'Applied Internships',
                    onTap: () {
                      final studentId = Provider.of<StudentProfileViewModel>(
                        context,
                        listen: false,
                      ).studentId;

                      if (studentId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentApplicationsPage(studentId: studentId),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Student ID is not available.')),
                        );
                      }
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

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Company ID is required to confirm internships.'),
                          ),
                        );
                      }
                    },
                  ),
                ],
                SidebarXItem(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Logging out...'),
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInView(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Powered by Stagi',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
