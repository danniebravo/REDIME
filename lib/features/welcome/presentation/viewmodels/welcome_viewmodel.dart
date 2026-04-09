import 'package:flutter/material.dart';
import '../../../../core/constants/app_routes.dart';

class WelcomeViewModel extends ChangeNotifier {
  /// Navigates to the login screen.
  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}
