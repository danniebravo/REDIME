import 'package:flutter/material.dart';

import '../core/database/auth_session.dart';
import '../core/database/repositories/usuario_repository.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    UsuarioRepository? repository,
    AuthSession? session,
  })  : _repository = repository ?? UsuarioRepository(),
        _session = session ?? AuthSession.instance;

  final UsuarioRepository _repository;
  final AuthSession _session;

  String email = '';
  String password = '';
  bool isLoading = false;
  String? errorMessage;
  UserModel? user;

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<bool> login() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final usuario = await _repository.authenticate(email, password);
      if (usuario == null) {
        errorMessage = 'Correo o contraseña inválidos';
        return false;
      }
      _session.setUser(usuario);
      user = UserModel(
        id: usuario.idUsuario.hashCode,
        usuario: usuario.correo,
        name: usuario.nombreCompleto,
      );
      return true;
    } catch (e) {
      errorMessage = 'No se pudo iniciar sesión: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
