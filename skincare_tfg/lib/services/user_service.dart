import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_config.dart';
import '../models/user.dart';

class UserService {
  Future<Map<String, dynamic>> getCurrentUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getUserByIdUrl(userId)),
        headers: {'Content-Type': 'application/json'},
      );
      print('📡 Login status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return {
            'success': true,
            'user': User.fromJson(data['data']),
          };
        }
      }
      
      return {
        'success': false,
        'message': 'Error al obtener usuario',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
  
  Future<Map<String, dynamic>> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse(ApiConfig.getUserByIdUrl(userId)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true && responseData['data'] != null) {
          return {
            'success': true,
            'user': User.fromJson(responseData['data']),
          };
        }
      }
      
      return {
        'success': false,
        'message': 'Error al actualizar usuario',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
  
  Future<Map<String, dynamic>> deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiConfig.getUserByIdUrl(userId)),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Usuario eliminado',
        };
      }
      
      return {
        'success': false,
        'message': 'Error al eliminar usuario',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
}