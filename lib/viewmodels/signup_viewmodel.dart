import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routes.dart';

class SignUpViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<void> signUp(String email, String password, BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      Navigator.pushReplacementNamed(context, AppRoutes.videoFeed);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = e.message ?? 'Sign up failed.';
      }
    } catch (e) {
      errorMessage = 'Sign up failed.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
