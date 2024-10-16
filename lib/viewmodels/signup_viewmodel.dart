
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart' as appUser;
import '../services/api_service_user.dart';

class SignUpViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

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


      String userIdFromApi = await _apiService.signUp(user);


      userId = userIdFromApi;
      await saveUserId(userId);
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
