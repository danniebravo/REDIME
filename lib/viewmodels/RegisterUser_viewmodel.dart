import 'package:flutter/material.dart';

import '../core/database/auth_session.dart';
import '../core/database/models/usuario.dart';
import '../core/database/repositories/usuario_repository.dart';
import '../models/user_model.dart';

class RegisterUserViewModel extends ChangeNotifier {
  RegisterUserViewModel({
    UsuarioRepository? repository,
    AuthSession? session,
  })  : _repository = repository ?? UsuarioRepository(),
        _session = session ?? AuthSession.instance;

  final UsuarioRepository _repository;
  final AuthSession _session;

  String nombre = '';
  String apellido = '';
  String email = '';
  String telefono = '';
  String direccion = '';
  String documento = '';
  String password = '';
  TipoUsuario tipoUsuario = TipoUsuario.donante;

  bool isLoading = false;
  String? errorMessage;
  UserModel? user;

  void setNombre(String value) {
    nombre = value;
    notifyListeners();
  }

  void setApellido(String value) {
    apellido = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setTelefono(String value) {
    telefono = value;
    notifyListeners();
  }

  void setDireccion(String value) {
    direccion = value;
    notifyListeners();
  }

  void setDocumento(String value) {
    documento = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setTipoUsuario(TipoUsuario value) {
    tipoUsuario = value;
    notifyListeners();
  }

  /// Kept for backwards compatibility with existing views that call `login()`.
  /// Delegates to [register].
  Future<bool> login() => register();

  Future<bool> register() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (!_validate()) return false;
      final usuario = await _repository.create(
        nombre: nombre,
        apellido: apellido.isEmpty ? '—' : apellido,
        correo: email,
        telefono: telefono.isEmpty ? '0000000000' : telefono,
        direccion: direccion.isEmpty ? null : direccion,
        documentoIdentidad:
            documento.isEmpty ? _fallbackDoc(email) : documento,
        tipoUsuario: tipoUsuario,
        password: password.isEmpty ? 'redime1234' : password,
      );
      _session.setUser(usuario);
      user = UserModel(
        id: usuario.idUsuario.hashCode,
        usuario: usuario.correo,
        name: usuario.nombreCompleto,
      );
      return true;
    } catch (e) {
      errorMessage = 'No se pudo registrar: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool _validate() {
    if (email.trim().isEmpty || !email.contains('@')) {
      errorMessage = 'Correo inválido';
      return false;
    }
    if (nombre.trim().isEmpty) {
      errorMessage = 'Ingresa tu nombre';
      return false;
    }
    return true;
  }

  String _fallbackDoc(String email) {
    final digits = email.codeUnits
        .map((c) => c % 10)
        .take(10)
        .join();
    return digits.isEmpty ? '0000000000' : digits;
  }
}
