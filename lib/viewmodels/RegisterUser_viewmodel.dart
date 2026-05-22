import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterUserViewModel extends ChangeNotifier {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String nombre = '';
  String apellido = '';
  String cedula = '';
  String celular = '';
  String nombreUsuario = '';

  bool isLoading = false;
  String? errorMessage;

  void clearError() {
    if (errorMessage == null) return;
    errorMessage = null;
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

  void setNombre(String value) {
    nombre = value;
    notifyListeners();
  }

  void setApellido(String value) {
    apellido = value;
    notifyListeners();
  }

  void setCedula(String value) {
    cedula = value;
    notifyListeners();
  }

  void setCelular(String value) {
    celular = value;
    notifyListeners();
  }

  void setNombreUsuario(String value) {
    nombreUsuario = value;
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

  Future register(BuildContext context) async {
    errorMessage = null;

    if (password.length < 6) {
      errorMessage = 'La contraseña debe tener al menos 6 caracteres';
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await _auth.register(
        email,
        password,
        nombre,
        apellido,
        cedula,
        celular,
        nombreUsuario,
      );
      print("REGISTER OK: $response");
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
