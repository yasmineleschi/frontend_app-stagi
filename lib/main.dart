// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/PublicationViewModel.dart';
import 'package:frontend_app_stagi/viewmodels/signin_viewmodel.dart';
import 'package:frontend_app_stagi/viewmodels/signup_viewmodel.dart';
import 'package:provider/provider.dart';
import 'views/authentification/signup_view.dart';
import 'views/authentification/signin_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignUpViewModel()),
        ChangeNotifierProvider(create: (context) => SignInViewModel()),
        ChangeNotifierProvider(create: (context) => PublicationViewModel()), // Add PublicationViewModel here
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
