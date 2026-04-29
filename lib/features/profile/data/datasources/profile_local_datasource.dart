import '../models/user_profile_model.dart';

class ProfileLocalDataSource {
  UserProfileModel _perfil = const UserProfileModel(
    id: 'user_001',
    nombres: 'Nombre De',
    apellidos: 'Usuario',
    celular: '323 3338922',
    correo: 'Usuario@gmail.com',
  );

  Future<UserProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _perfil;
  }

  Future<void> updateProfile(UserProfileModel model) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _perfil = model;
  }

  Future<void> deleteAccount(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Credenciales inválidas');
    }
  }
}