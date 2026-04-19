import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

class RegisterUserViewModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool isLoading = false;
  UserModel? user;

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<void> login() async {
    isLoading = true;
    notifyListeners();

    isLoading = false;
    notifyListeners();
  }
}
