import 'package:flutter/foundation.dart';

import 'models/usuario.dart';

/// Process-wide holder for the currently signed-in user. Kept deliberately
/// small: login/register write to it, and any feature that needs the user
/// id (pickup flow, preferences) reads from it.
class AuthSession extends ChangeNotifier {
  AuthSession._();
  static final AuthSession instance = AuthSession._();

  Usuario? _current;
  Usuario? get current => _current;
  bool get isAuthenticated => _current != null;

  /// Fallback used before the user logs in (e.g. the very first launch when
  /// someone tests the pickup flow without signing up). Maps to the demo user
  /// seeded in the database.
  String get effectiveUserId => _current?.idUsuario ?? 'demo-user-0001';

  void setUser(Usuario user) {
    _current = user;
    notifyListeners();
  }

  void signOut() {
    _current = null;
    notifyListeners();
  }
}
