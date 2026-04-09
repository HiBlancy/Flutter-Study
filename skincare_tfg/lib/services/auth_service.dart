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
    await prefs.setString(AppConstants.prefUserPhone, userData['phone'] ?? '');
    await prefs.setString(AppConstants.prefUserBD, userData['birthDate'] ?? '');
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
    return name;
  }
  
  // Obtener email del usuario
  Future<String?> getUserEmail() async {
    final prefs = await _prefs;
    final email = prefs.getString(AppConstants.prefUserEmail);
    return email;
  }
  
  // Obtener ID del usuario
  Future<String?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.prefUserId);
  }

  
  // Obtener teléfono
  Future<String?> getUserPhone() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.prefUserPhone);
  }

  // Obtener fecha de nacimiento
  Future<String?> getUserBirthDate() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.prefUserBD);
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
    
    final cleanPassword = password;
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': cleanPassword,
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

Future<Map<String, dynamic>?> login(String email, String password) async {
  try {
    final url = Uri.parse(ApiConfig.getLoginUrl());
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    ).timeout(const Duration(seconds: 10));
    

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('📦 Parsed data: $data');
      
      if (data['status'] == true && data['data'] != null) {
        final authData = data['data'];
        await saveSession(authData['token'], authData['user']);
        return authData;
      } else {
        print('❌ Status false o data null');
        return null;
      }
    } else {
      print('❌ Status code no es 200/201: ${response.statusCode}');
      print('❌ Response: ${response.body}');
      return null;
    }
  } catch (e) {
    print('❌ Excepción en login: $e');
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

  // Actualizar usuario
  Future<Map<String, dynamic>?> updateUser({
  String? name,
  String? phone,
  String? birthDate,
  String? profileImage,
  String? password,
}) async {
  final token = await getToken();
  if (token == null) return null;

  try {
    final url = Uri.parse(ApiConfig.getProfileUrl());
    
    final Map<String, dynamic> updateData = {};
    if (name != null && name.isNotEmpty) updateData['name'] = name;
    if (phone != null && phone.isNotEmpty) updateData['phone'] = phone;
    if (birthDate != null && birthDate.isNotEmpty) updateData['birthDate'] = birthDate;
    if (profileImage != null && profileImage.isNotEmpty) updateData['profileImage'] = profileImage;
    if (password != null && password.isNotEmpty) updateData['password'] = password;

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        final updatedUser = data['data'];
        final prefs = await _prefs;
        
        // Actualizar campos en SharedPreferences
        if (updatedUser['name'] != null) {
          await prefs.setString(AppConstants.prefUserName, updatedUser['name']);
        }
        if (updatedUser['phone'] != null) {
          await prefs.setString(AppConstants.prefUserPhone, updatedUser['phone']);
        }
        if (updatedUser['birthDate'] != null) {
          // Guardar en formato ISO para consistencia
          await prefs.setString(AppConstants.prefUserBD, updatedUser['birthDate']);
        }
        
        print('✅ Usuario actualizado correctamente');
        return updatedUser;
      }
    }
    
    print('❌ Error al actualizar: ${response.body}');
    return null;
  } catch (e) {
    print('❌ Error al actualizar usuario: $e');
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
    await prefs.remove(AppConstants.prefUserPhone);
    await prefs.remove(AppConstants.prefUserBD);
    await prefs.setBool(AppConstants.prefIsLoggedIn, false);
    print('👋 Sesión cerrada');
  }
}