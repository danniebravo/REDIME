import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  static final String login = '$baseUrl/auth/login';

  static final String register = '$baseUrl/auth/register';
}
