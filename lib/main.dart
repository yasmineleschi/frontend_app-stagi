import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/HomeSearchViewModel.dart';
import 'package:frontend_app_stagi/viewmodels/attachment_viewmodel.dart';
import 'package:frontend_app_stagi/viewmodels/company_viewmodel.dart';
import 'package:frontend_app_stagi/viewmodels/student_viewmodel.dart';
import 'package:frontend_app_stagi/viewmodels/PublicationViewModel.dart';
import 'package:frontend_app_stagi/viewmodels/signin_viewmodel.dart';
import 'package:frontend_app_stagi/viewmodels/auth_viewmodel.dart';
import 'package:frontend_app_stagi/views/Profil/Company/company_view.dart';
import 'package:frontend_app_stagi/views/Profil/Company/create_companyprofile_view.dart';
import 'package:frontend_app_stagi/views/Profil/Student/Student_view.dart';
import 'package:frontend_app_stagi/views/Profil/Student/create_studentprofile_view.dart';
import 'package:frontend_app_stagi/views/authentification/signin_view.dart';
import 'package:frontend_app_stagi/views/authentification/signup_view.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignUpViewModel()),
        ChangeNotifierProvider(create: (context) => SignInViewModel()),
        ChangeNotifierProvider(create: (context) => PublicationViewModel()),
        ChangeNotifierProvider(create: (context) => StudentProfileViewModel()),
        ChangeNotifierProvider(create: (context) => HomeSearchViewModel()),
        ChangeNotifierProvider(create: (context) => CompanyProfileViewModel()),
        ChangeNotifierProvider(create: (context) => AttachmentViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/signin',
        routes: {
          '/signin': (context) => const SignInView(),
          '/signup': (context) => const SignUpView(),
          '/profileStepper': (context) => ProfileStepper(userId: 'userId'),
          '/companyProfileStepper': (context) => CompanyProfileStepper(userId: 'userId'),
          '/companyProfileView': (context) => CompanyProfileView(userId: 'userId'),
          '/studentProfileView': (context) => StudentProfileView(userId: 'userId'),
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SignInView(),
        ),
      ),
    );
  }
}
