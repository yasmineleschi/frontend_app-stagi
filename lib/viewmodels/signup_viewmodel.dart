import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as appUser;
import '../services/api_service_user.dart';

class SignUpViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String username = '';
  String email = '';
  String password = '';
  String role = 'Student';
  String errorMessage = '';
  bool isLoading = false;
  late String userId  = "" ;

  void setUsername(String value) {
    username = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setRole(String value) {
    role = value;
    notifyListeners();
  }

  Future<void> signUp() async {
    if (username.isEmpty || email.isEmpty || password.isEmpty || role.isEmpty) {
      errorMessage = "All fields are mandatory!";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      appUser.User user = appUser.User(
        username: username,
        email: email,
        password: password,
        role: role,
      );

      await _apiService.signUp(user);


      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      appUser.User user = appUser.User(
        username: userCredential.user?.displayName ?? '',
        email: userCredential.user?.email ?? '',
        password: '',
        role: 'Student',
      );

      await _apiService.signUpWithGoogle(user);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
