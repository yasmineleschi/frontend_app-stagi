import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/HomeSearchViewModel.dart';
import 'package:frontend_app_stagi/viewmodels/company_viewmodel.dart';
import 'package:frontend_app_stagi/viewmodels/student_viewmodel.dart';
import 'package:frontend_app_stagi/viewmodels/PublicationViewModel.dart';
import 'package:frontend_app_stagi/viewmodels/signin_viewmodel.dart';
import 'package:frontend_app_stagi/viewmodels/auth_viewmodel.dart';
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

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/signin',
        routes: {
          '/signin': (context) => const SignInView(),
          '/signup': (context) => const SignUpView(),
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SignInView(),

        ),
      ),
    );
  }
}
