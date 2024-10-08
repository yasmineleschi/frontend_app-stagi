import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/signup_view.dart';
import 'viewmodels/signup_viewmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpViewModel(),
      child: MaterialApp(
        home: SignUpView(),
      debugShowCheckedModeBanner: false,
      ),
    );
  }
}