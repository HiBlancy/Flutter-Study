
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/routine_model.dart';
import 'auth_service.dart';
import 'api_config.dart';

class RoutineService {
  final AuthService _authService = AuthService();

  Map<String, dynamic> _decodeJson(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    return {'data': decoded};
  }

  Map<String, dynamic>? _extractDataObject(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {

      final inner = data['data'];
      if (inner is Map<String, dynamic>) return inner;
      return data;
    }
    return null;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }


  Future<List<Routine>> getRoutines() async {
    final headers = await _getHeaders();
    // API call
    final response = await http.get(
      Uri.parse(ApiConfig.getRoutinesUrl()),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final json = _decodeJson(response);

    final dynamic maybeData = json['data'];
    final List<dynamic> data = maybeData is Map<String, dynamic>
        ? (maybeData['data'] as List<dynamic>? ?? [])
        : (maybeData as List<dynamic>? ?? []);
    final routines = data
        .whereType<Map<String, dynamic>>()
        .map((r) {
          if (kDebugMode) {
            final raw = r['type'] ??
                r['routineType'] ??
                r['moment'] ??
                r['timeOfDay'] ??
                r['isNight'] ??
                r['night'] ??
                r['isMorning'];
            debugPrint('🧴 Routine ${r['_id']}: rawType=$raw');
          }
          return Routine.fromJson(r);
        })
        .toList();
    return routines;
  }


  Future<Routine> createRoutine(Routine routine) async {
    final headers = await _getHeaders();
    final bodyMap = routine.toJson();

    bodyMap['routineType'] = bodyMap['type'];
    bodyMap['moment'] = bodyMap['type'];
    bodyMap['timeOfDay'] = bodyMap['type'];
    bodyMap['time'] = bodyMap['type'];
    bodyMap['daysOfWeek'] = bodyMap['days'];
    bodyMap['weekDays'] = bodyMap['days'];
    bodyMap['isNight'] = bodyMap['type'] == 'night';
    bodyMap['isMorning'] = bodyMap['type'] == 'morning';
    bodyMap['message'] = bodyMap['name'];

    // API call
    final response = await http.post(
      Uri.parse(ApiConfig.getRoutinesUrl()),
      headers: headers,
      body: jsonEncode(bodyMap),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear rutina (${response.statusCode}): ${response.body}');
    }

    final json = _decodeJson(response);
    final dataObj = _extractDataObject(json);
    if (dataObj == null) {
      throw Exception('Respuesta inesperada al crear rutina: ${response.body}');
    }
    return Routine.fromJson(dataObj);
  }


  Future<Routine> updateRoutine(String id, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final payload = Map<String, dynamic>.from(data);

    if (payload.containsKey('type')) {
      payload['routineType'] = payload['type'];
      payload['moment'] = payload['type'];
      payload['timeOfDay'] = payload['type'];
      payload['time'] = payload['type'];
      payload['isNight'] = payload['type'] == 'night';
      payload['isMorning'] = payload['type'] == 'morning';
    }
    if (payload.containsKey('days')) {
      payload['daysOfWeek'] = payload['days'];
      payload['weekDays'] = payload['days'];
    }
    if (payload.containsKey('name')) {
      payload['message'] = payload['name'];
    }

    // API call
    final response = await http.patch(
      Uri.parse('${ApiConfig.getRoutinesUrl()}/$id'),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar rutina (${response.statusCode}): ${response.body}');
    }

    final json = _decodeJson(response);
    final dataObj = _extractDataObject(json);
    if (dataObj == null) {
      throw Exception('Respuesta inesperada al actualizar rutina: ${response.body}');
    }
    return Routine.fromJson(dataObj);
  }


  Future<void> deleteRoutine(String id) async {
    final headers = await _getHeaders();
    // API call
    final response = await http.delete(
      Uri.parse('${ApiConfig.getRoutinesUrl()}/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar rutina (${response.statusCode}): ${response.body}');
    }
  }


  Future<Routine> addProduct(String routineId, String productId) async {
    final headers = await _getHeaders();
    // API call
    final response = await http.post(
      Uri.parse('${ApiConfig.getRoutinesUrl()}/$routineId/products'),
      headers: headers,
      body: jsonEncode({'productId': productId}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al añadir producto (${response.statusCode}): ${response.body}');
    }

    final json = _decodeJson(response);
    final dataObj = _extractDataObject(json);
    if (dataObj == null) {
      throw Exception('Respuesta inesperada al añadir producto: ${response.body}');
    }
    return Routine.fromJson(dataObj);
  }


  Future<Routine> removeProduct(String routineId, String productId) async {
    final headers = await _getHeaders();
    // API call
    final response = await http.delete(
      Uri.parse('${ApiConfig.getRoutinesUrl()}/$routineId/products/$productId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar producto (${response.statusCode}): ${response.body}');
    }

    final json = _decodeJson(response);
    final dataObj = _extractDataObject(json);
    if (dataObj == null) {
      throw Exception('Respuesta inesperada al eliminar producto: ${response.body}');
    }
    return Routine.fromJson(dataObj);
  }


  Future<Routine> reorderProducts(
    String routineId,
    List<Map<String, dynamic>> products,
  ) async {
    final headers = await _getHeaders();
    // API call
    final response = await http.patch(
      Uri.parse('${ApiConfig.getRoutinesUrl()}/$routineId/reorder'),
      headers: headers,
      body: jsonEncode({'products': products}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al reordenar productos (${response.statusCode}): ${response.body}');
    }

    final json = _decodeJson(response);
    final dataObj = _extractDataObject(json);
    if (dataObj == null) {
      throw Exception('Respuesta inesperada al reordenar: ${response.body}');
    }
    return Routine.fromJson(dataObj);
  }


Future<Routine?> getRoutineById(String id) async {
  final headers = await _getHeaders();
  // API call
  final response = await http.get(
    Uri.parse('${ApiConfig.getRoutinesUrl()}/$id'),
    headers: headers,
  );

  if (response.statusCode != 200) return null;

  final json = _decodeJson(response);
  final dataObj = _extractDataObject(json);
  if (dataObj == null) return null;
  return Routine.fromJson(dataObj);
}
}