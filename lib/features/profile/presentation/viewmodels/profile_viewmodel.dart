import 'package:flutter/material.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../../domain/entities/user_profile_entity.dart';

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

  // ─── Estado ──────────────────────────────────────────────────────────────
  ProfileState state = ProfileState.idle;
  String? errorMessage;
  UserProfileEntity? profile;

  // ─── Controladores de edición ─────────────────────────────────────────────
  late TextEditingController nombresController;
  late TextEditingController apellidosController;
  late TextEditingController celularController;
  late TextEditingController correoController;

  String? campoEditando;

  bool get isLoading => state == ProfileState.loading;

  // ─── Cargar perfil ────────────────────────────────────────────────────────
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

  // ─── Activar edición de campo ─────────────────────────────────────────────
  void editarCampo(String campo) {
    campoEditando = campoEditando == campo ? null : campo;
    notifyListeners();
  }

  // ─── Guardar perfil ───────────────────────────────────────────────────────
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

  // ─── Eliminar cuenta ──────────────────────────────────────────────────────
  bool deleteLoading = false;
  String? deleteError;

  Future<bool> eliminarCuenta(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      deleteError = 'Por favor completa todos los campos';
      notifyListeners();
      return false;
    }

    deleteLoading = true;
    deleteError = null;
    notifyListeners();

    try {
      await deleteAccountUseCase(email, password);
      deleteLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      deleteError = 'Credenciales incorrectas. Inténtalo de nuevo.';
      deleteLoading = false;
      notifyListeners();
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