import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

  bool isLoading = false;
  String? errorMessage;

  void setEmail(String value) {
    email = value;
    if (errorMessage != null) errorMessage = null;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    if (errorMessage != null) errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    if (errorMessage == null) return;
    errorMessage = null;
    notifyListeners();
  }

  Future login(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _auth.login(email, password);
      print("LOGIN OK: $response");
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    isLoading = false;
    notifyListeners();
  }

  Future loginWithGoogle(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _auth.loginWithGoogle();
      if (response == null) return;
      print("GOOGLE LOGIN OK: $response");
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
