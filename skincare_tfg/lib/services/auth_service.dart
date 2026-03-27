import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'api_config.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  
  Future<SharedPreferences> get _prefs async => 
      await SharedPreferences.getInstance();
  
  // Guardar token y datos de usuario
  Future<void> saveSession(String token, Map<String, dynamic> userData) async {
    final prefs = await _prefs;
    await prefs.setString(_tokenKey, token);
    await prefs.setString(AppConstants.prefUserEmail, userData['email'] ?? '');
    await prefs.setString(AppConstants.prefUserName, userData['name'] ?? '');
    await prefs.setString(AppConstants.prefUserId, userData['_id'] ?? '');
    await prefs.setBool(AppConstants.prefIsLoggedIn, true);
    
    print('✅ Sesión guardada - Email: ${userData['email']}, Name: ${userData['name']}');
  }
  
  // Obtener token
  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }
  
  // Obtener nombre del usuario
  Future<String?> getUserName() async {
    final prefs = await _prefs;
    final name = prefs.getString(AppConstants.prefUserName);
    print('📛 Obteniendo nombre de usuario: $name');
    return name;
  }
  
  // Obtener email del usuario
  Future<String?> getUserEmail() async {
    final prefs = await _prefs;
    final email = prefs.getString(AppConstants.prefUserEmail);
    print('📧 Obteniendo email de usuario: $email');
    return email;
  }
  
  // Obtener ID del usuario
  Future<String?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.prefUserId);
  }
  
  // Verificar si está autenticado
  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    final token = prefs.getString(_tokenKey);
    final isLoggedIn = token != null && token.isNotEmpty;
    print('🔐 Verificando autenticación: $isLoggedIn');
    return isLoggedIn;
  }
  
  // Registrar usuario con JWT
  Future<Map<String, dynamic>?> register(String email, String password, String name) async {
  try {
    final url = Uri.parse(ApiConfig.getRegisterUrl());
    
    // IMPORTANTE: Enviar la contraseña en texto plano, NO hasheada
    final cleanPassword = password; // No aplicar ningún hash
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': cleanPassword, // Enviar texto plano
      }),
    ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['status'] == true && data['data'] != null) {
          final authData = data['data'];
          await saveSession(authData['token'], authData['user']);
          return authData;
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // Iniciar sesión con JWT
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final url = Uri.parse(ApiConfig.getLoginUrl());
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['status'] == true && data['data'] != null) {
          final authData = data['data'];
          await saveSession(authData['token'], authData['user']);
          return authData;
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // Obtener perfil del usuario autenticado
  Future<Map<String, dynamic>?> getProfile() async {
    final token = await getToken();
    if (token == null) return null;
    
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getProfileUrl()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-token': token,
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          // Actualizar los datos en SharedPreferences
          final userData = data['data'];
          await saveSession(token, userData);
          return userData;
        }
      }
      return null;
    } catch (e) {
      print('❌ Error al obtener perfil: $e');
      return null;
    }
  }
  
  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(_tokenKey);
    await prefs.remove(AppConstants.prefUserEmail);
    await prefs.remove(AppConstants.prefUserName);
    await prefs.remove(AppConstants.prefUserId);
    await prefs.setBool(AppConstants.prefIsLoggedIn, false);
    print('👋 Sesión cerrada');
  }
}