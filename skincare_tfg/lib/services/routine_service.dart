// lib/services/routine_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/routine_model.dart';
import 'auth_service.dart';
import 'api_config.dart'; // ← igual que product_service.dart

class RoutineService {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET /routines
  Future<List<Routine>> getRoutines() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse(ApiConfig.getRoutinesUrl()),
      headers: headers,
    );

    if (response.statusCode != 200) throw Exception('Error ${response.statusCode}');

    final json = jsonDecode(response.body);
    // El controller devuelve: { status, data: { data: [...], total: N } }
    final List<dynamic> data = json['data']['data'] ?? [];
    return data.map((r) => Routine.fromJson(r as Map<String, dynamic>)).toList();
  }

  // POST /routines
  Future<Routine> createRoutine(Routine routine) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse(ApiConfig.getRoutinesUrl()),
      headers: headers,
      body: jsonEncode(routine.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear rutina');
    }

    final json = jsonDecode(response.body);
    return Routine.fromJson(json['data']);
  }

  // PATCH /routines/:id
  Future<Routine> updateRoutine(String id, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('${ApiConfig.getRoutinesUrl()}/$id'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) throw Exception('Error al actualizar rutina');

    final json = jsonDecode(response.body);
    return Routine.fromJson(json['data']);
  }

  // DELETE /routines/:id
  Future<void> deleteRoutine(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.getRoutinesUrl()}/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) throw Exception('Error al eliminar rutina');
  }

  // POST /routines/:id/products
  Future<Routine> addProduct(String routineId, String productId) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.getRoutinesUrl()}/$routineId/products'),
      headers: headers,
      body: jsonEncode({'productId': productId}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al añadir producto');
    }

    final json = jsonDecode(response.body);
    return Routine.fromJson(json['data']);
  }

  // DELETE /routines/:id/products/:productId
  Future<Routine> removeProduct(String routineId, String productId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.getRoutinesUrl()}/$routineId/products/$productId'),
      headers: headers,
    );

    if (response.statusCode != 200) throw Exception('Error al eliminar producto');

    final json = jsonDecode(response.body);
    return Routine.fromJson(json['data']);
  }

  // PATCH /routines/:id/reorder
  Future<Routine> reorderProducts(
    String routineId,
    List<Map<String, dynamic>> products,
  ) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('${ApiConfig.getRoutinesUrl()}/$routineId/reorder'),
      headers: headers,
      body: jsonEncode({'products': products}),
    );

    if (response.statusCode != 200) throw Exception('Error al reordenar productos');

    final json = jsonDecode(response.body);
    return Routine.fromJson(json['data']);
  }

  // GET /routines/:id
Future<Routine?> getRoutineById(String id) async {
  final headers = await _getHeaders();
  final response = await http.get(
    Uri.parse('${ApiConfig.getRoutinesUrl()}/$id'),
    headers: headers,
  );

  if (response.statusCode != 200) return null;

  final json = jsonDecode(response.body);
  return Routine.fromJson(json['data']);
}
}