import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

enum ProfileState { idle, loading, success, error }

class ProfileViewModel extends ChangeNotifier {
  final AuthService _authService;

  ProfileViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  ProfileState _state = ProfileState.idle;
  UserModel? _user;
  String? _errorMessage;

  ProfileState get state => _state;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ProfileState.loading;
  bool get hasError => _state == ProfileState.error;
  bool get isSuccess => _state == ProfileState.success;

  Future<void> loadProfile() async {
    _state = ProfileState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.getProfile();
      _state = ProfileState.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ProfileState.error;
    }

    notifyListeners();
  }

  Future<void> saveProfile(
    BuildContext context, {
    required String nombre,
    required String apellido,
    required String celular,
    required String email,
  }) async {
    final current = _user;
    if (current == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay un perfil cargado para actualizar')),
      );
      return;
    }

    _state = ProfileState.loading;
    _errorMessage = null;
    notifyListeners();

    final updated = UserModel(
      id: current.id,
      nombre: nombre,
      apellido: apellido,
      nombreUsuario: current.nombreUsuario,
      email: email,
      celular: celular,
      cedula: current.cedula,
    );

    try {
      _user = await _authService.updateProfile(updated);
      _state = ProfileState.success;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente')),
        );
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ProfileState.error;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $_errorMessage')),
        );
      }
    }
  }
}
