import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

  bool isLoading = false;

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future login(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _auth.login(email, password);

      print("LOGIN OK: $response");

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    isLoading = false;
    notifyListeners();
  }

  Future loginWithGoogle(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _auth.loginWithGoogle();
      if (response == null) return;

      print("GOOGLE LOGIN OK: $response");

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
