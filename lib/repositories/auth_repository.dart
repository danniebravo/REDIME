import '../services/api_service.dart';
import '../models/user_model.dart';

class UsuarioRepository {
  final ApiService _api = ApiService();

  Future<UserModel?> authenticate(String email, String password) async {
    final response = await _api.post('auth/login', {
      "email": email,
      "password": password,
    });

    if (response == null || response['data'] == null) {
      return null;
    }

    final userJson = response['data']['user'];

    return UserModel.fromJson(userJson);
  }
}
