import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/student_viewmodel.dart';
import 'package:provider/provider.dart';
import 'views/authentification/signup_view.dart';
import 'viewmodels/signup_viewmodel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StudentProfileViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpViewModel(),
      child: const MaterialApp(
        home: SignUpView(),
      debugShowCheckedModeBanner: false,
      ),
    );
  }
}