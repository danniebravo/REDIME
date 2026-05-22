import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  static final String googleWebClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

  static final String login = '$baseUrl/auth/login';

  static final String register = '$baseUrl/auth/register';

  static final String google = '$baseUrl/auth/google';

  static final String changePassword = '$baseUrl/auth/change-password';

  static final String profile = '$baseUrl/auth/profile';

  static final String deleteAccount = '$baseUrl/auth/account';

  static final String pickups = '$baseUrl/pickups';

  static final String myPickups = '$baseUrl/pickups/me';
}
