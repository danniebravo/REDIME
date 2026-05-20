import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/pickup_model.dart';
import 'auth_service.dart';

class PickupService {
  final AuthService _auth;

  PickupService({AuthService? auth}) : _auth = auth ?? AuthService();

  Future<PickupModel> createPickup(PickupModel pickup) async {
    final token = await _auth.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No hay sesión activa');
    }

    final response = await http.post(
      Uri.parse(ApiConstants.pickups),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(pickup.toJson()),
    );

    debugPrint(
      '[PickupService.createPickup] status=${response.statusCode} body=${response.body}',
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201 && data['success'] == true) {
      return PickupModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    throw Exception(data['message'] ?? 'Error creando el pickup');
  }

  Future<List<PickupModel>> getMyPickups() async {
    final token = await _auth.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No hay sesión activa');
    }

    final response = await http.get(
      Uri.parse(ApiConstants.myPickups),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint(
      '[PickupService.getMyPickups] status=${response.statusCode} body=${response.body}',
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && data['success'] == true) {
      final list = (data['data'] as List).cast<Map<String, dynamic>>();
      return list.map(PickupModel.fromJson).toList();
    }

    throw Exception(data['message'] ?? 'Error obteniendo los pickups');
  }
}
