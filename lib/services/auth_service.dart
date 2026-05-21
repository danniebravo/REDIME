import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/api_constants.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _tokenKey = 'token';

  // ---------- TOKEN STORAGE ----------
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ---------- GOOGLE LOGIN ----------
  Future loginWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      serverClientId: ApiConstants.googleWebClientId,
      scopes: const ['email', 'profile'],
    );

    await googleSignIn.signOut();
    final account = await googleSignIn.signIn();
    if (account == null) return null;

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw Exception('No se pudo obtener el idToken de Google');
    }

    final response = await http.post(
      Uri.parse(ApiConstants.google),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"idToken": idToken}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['data']?['token'];
      if (token is String && token.isNotEmpty) {
        await saveToken(token);
      }
      return data;
    } else {
      throw Exception(data["message"]);
    }
  }

  // ---------- LOGIN ----------
  Future login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['data']?['token'];
      if (token is String && token.isNotEmpty) {
        await saveToken(token);
      }
      return data;
    } else {
      throw Exception(data["message"]);
    }
  }

  // ---------- REGISTER ----------
  Future register(
    String email,
    String password,
    String nombre,
    String apellido,
    String cedula,
    String celular, [
    String nombreUsuario = '',
  ]) async {
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
        "nombre_usuario": nombreUsuario,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"]);
    }
  }

  // ---------- PROFILE ----------
  Future<UserModel> getProfile() async {
    final token = await getToken();
    debugPrint('[AuthService.getProfile] token=$token');

    if (token == null || token.isEmpty) {
      throw Exception('No hay sesión activa');
    }

    final response = await http.get(
      Uri.parse(ApiConstants.profile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint(
      '[AuthService.getProfile] status=${response.statusCode} body=${response.body}',
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && data['success'] == true) {
      return UserModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    throw Exception(data['message'] ?? 'Error obteniendo el perfil');
  }

  // ---------- UPDATE PROFILE ----------
  Future<UserModel> updateProfile(UserModel user) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No hay sesión activa');
    }

    final response = await http.put(
      Uri.parse(ApiConstants.profile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && data['success'] == true) {
      return UserModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    throw Exception(data['message'] ?? 'Error actualizando el perfil');
  }

  // ---------- DELETE ACCOUNT ----------
  Future<bool> deleteAccount(String email, String password) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No hay sesión activa');
    }

    final response = await http.delete(
      Uri.parse(ApiConstants.deleteAccount),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && data['success'] == true) {
      return true;
    }

    throw Exception(data['message'] ?? 'Error eliminando la cuenta');
  }
}
