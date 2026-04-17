import 'package:flutter/material.dart';

class DeleteAccountViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters para la vista (UI)
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Regla de validación: ambos campos llenos con formatos básicos para habilitar el botón
  bool get canSubmit {
    return _email.isNotEmpty && _email.contains('@') && _password.length >= 6;
  }

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<void> deleteAccount(BuildContext context) async {
    if (!canSubmit) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulación de interacción con la capa de UseCase/Dominio
      await Future.delayed(const Duration(seconds: 2));
      
      // Validación Mock de identidad antes de proceder (criterio 5)
      if (_email != 'usuario@redime.com' || _password != '123456') {
        throw Exception('Credenciales incorrectas');
      }

      print('Cuenta eliminada exitosamente. Se debería cerrar sesión o redirigir.');
      // Navigator.of(context).pushReplacementNamed('/welcome');
      
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
