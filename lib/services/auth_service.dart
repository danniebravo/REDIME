import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';

class AuthService {
  // LOGIN
  Future login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["message"]);
    }
  }

  // REGISTER
  Future register(
    String email,
    String password,
    String nombre,
    String apellido,
    String cedula,
    String celular,
  ) async {
    final response = await http.post(
      Uri.parse(ApiConstants.register),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({
        "email": email,
        "password": password,
        "nombre": nombre,
        "apellido": apellido,
        "cedula": cedula,
        "celular": celular,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"]);
    }
  }
}
