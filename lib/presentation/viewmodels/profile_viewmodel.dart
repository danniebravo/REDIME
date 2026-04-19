import 'package:flutter/material.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/profile_usecases.dart';

enum ProfileState { idle, loading, success, error }

class ProfileViewModel extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  ProfileViewModel({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.deleteAccountUseCase,
  });

  ProfileState state = ProfileState.idle;
  String? errorMessage;
  UserProfileEntity? profile;

  late TextEditingController nombresController;
  late TextEditingController apellidosController;
  late TextEditingController celularController;
  late TextEditingController correoController;

  String? campoEditando;
  bool get isLoading => state == ProfileState.loading;

  Future<void> loadProfile() async {
    state = ProfileState.loading;
    notifyListeners();
    try {
      profile = await getProfileUseCase();
      nombresController = TextEditingController(text: profile!.nombres);
      apellidosController = TextEditingController(text: profile!.apellidos);
      celularController = TextEditingController(text: profile!.celular);
      correoController = TextEditingController(text: profile!.correo);
      state = ProfileState.success;
    } catch (e) {
      errorMessage = 'Error al cargar el perfil';
      state = ProfileState.error;
    }
    notifyListeners();
  }

  void editarCampo(String campo) {
    campoEditando = campoEditando == campo ? null : campo;
    notifyListeners();
  }

  Future<bool> guardarPerfil() async {
    if (profile == null) return false;
    state = ProfileState.loading;
    notifyListeners();
    try {
      final actualizado = profile!.copyWith(
        nombres: nombresController.text.trim(),
        apellidos: apellidosController.text.trim(),
        celular: celularController.text.trim(),
        correo: correoController.text.trim(),
      );
      await updateProfileUseCase(actualizado);
      profile = actualizado;
      campoEditando = null;
      state = ProfileState.success;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Error al guardar el perfil';
      state = ProfileState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarCuenta(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) return false;
    try {
      await deleteAccountUseCase(email, password);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    nombresController.dispose();
    apellidosController.dispose();
    celularController.dispose();
    correoController.dispose();
    super.dispose();
  }
}