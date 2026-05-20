import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthService _authService;

  HomeViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  UserModel? user;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadUser() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final token = await _authService.getToken();
    debugPrint('[HomeViewModel.loadUser] token=$token');

    try {
      user = await _authService.getProfile();
      debugPrint(
        '[HomeViewModel.loadUser] user cargado: id=${user?.id} '
        'nombreUsuario="${user?.nombreUsuario}" nombre="${user?.nombre}" '
        'apellido="${user?.apellido}" email="${user?.email}"',
      );
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('[HomeViewModel.loadUser] error: $errorMessage');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
