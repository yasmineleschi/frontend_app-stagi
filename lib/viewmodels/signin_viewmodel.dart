import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class SignInViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String errorMessage = '';
  bool isLoading = false;

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<void> signIn() async {
    if (email.isEmpty || password.isEmpty) {
      errorMessage = "Email and password are required!";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
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

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
