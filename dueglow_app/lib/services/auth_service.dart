import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'api_config.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();


  Future<void> saveSession(String token, Map<String, dynamic> userData) async {
    final prefs = await _prefs;
    await prefs.setString(_tokenKey, token);
    await prefs.setString(AppConstants.prefUserEmail, userData['email'] ?? '');
    await prefs.setString(AppConstants.prefUserName, userData['name'] ?? '');
    await prefs.setString(AppConstants.prefUserId, userData['_id'] ?? '');
    await prefs.setString(AppConstants.prefUserPhone, userData['phone'] ?? '');
    await prefs.setString(AppConstants.prefUserBD, userData['birthDate'] ?? '');
    await prefs.setString(
      AppConstants.prefUserProfileImage,
      userData['profileImage'] ?? '',
    );
    await prefs.setBool(AppConstants.prefIsLoggedIn, true);

    print(
      '✅ Sesión guardada - Email: ${userData['email']}, Name: ${userData['name']}',
    );
  }


  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }

  /// Returns the token's expiry date extracted from the JWT `exp` claim.
  /// If the token is not a valid JWT or has no `exp`, returns null.
  DateTime? getTokenExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decoded);
      if (json is! Map<String, dynamic>) return null;

      final exp = json['exp'];
      if (exp is! num) return null;
      return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000, isUtc: true);
    } catch (_) {
      return null;
    }
  }

  bool isTokenValid(
    String token, {
    Duration clockSkew = const Duration(seconds: 30),
  }) {
    final expiryUtc = getTokenExpiry(token);
    if (expiryUtc == null) return token.isNotEmpty;
    return DateTime.now().toUtc().isBefore(expiryUtc.subtract(clockSkew));
  }


  Future<String?> getUserName() async {
    final prefs = await _prefs;
    final name = prefs.getString(AppConstants.prefUserName);
    return name;
  }


  Future<String?> getUserEmail() async {
    final prefs = await _prefs;
    final email = prefs.getString(AppConstants.prefUserEmail);
    return email;
  }


  Future<String?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.prefUserId);
  }


  Future<String?> getUserPhone() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.prefUserPhone);
  }


  Future<String?> getUserBirthDate() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.prefUserBD);
  }


  Future<String?> getUserProfileImage() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.prefUserProfileImage);
  }


  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    final token = prefs.getString(_tokenKey);
    final isLoggedIn = token != null && token.isNotEmpty;
    print('🔐 Verificando autenticación: $isLoggedIn');
    return isLoggedIn;
  }


  Future<Map<String, dynamic>?> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final url = Uri.parse(ApiConfig.getRegisterUrl());

      final cleanPassword = password;

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': cleanPassword,
            }),
          )
          .timeout(const Duration(seconds: 10));

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

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email.trim(), 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

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


  Future<Map<String, dynamic>?> getProfile() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      // API call
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


  Future<Map<String, dynamic>?> updateUser({
    String? name,
    String? phone,
    String? birthDate,
    String? password,
    String? profileImage,
  }) async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final url = Uri.parse(ApiConfig.getProfileUrl());

      final Map<String, dynamic> updateData = {};
      if (name != null && name.isNotEmpty) updateData['name'] = name;
      if (phone != null && phone.isNotEmpty) updateData['phone'] = phone;
      if (birthDate != null && birthDate.isNotEmpty)
        updateData['birthDate'] = birthDate;
      if (password != null && password.isNotEmpty)
        updateData['password'] = password;
      if (profileImage != null && profileImage.isNotEmpty)
        updateData['profileImage'] = profileImage;

      // API call
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


          if (updatedUser['name'] != null) {
            await prefs.setString(
              AppConstants.prefUserName,
              updatedUser['name'],
            );
          }
          if (updatedUser['phone'] != null) {
            await prefs.setString(
              AppConstants.prefUserPhone,
              updatedUser['phone'],
            );
          }
          if (updatedUser['birthDate'] != null) {
            await prefs.setString(
              AppConstants.prefUserBD,
              updatedUser['birthDate'],
            );
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


  /// Solicita al servidor eliminar la cuenta y todos los datos asociados.
  /// Si el backend responde correctamente, limpia la sesión local ([logout]).
  /// El endpoint esperado es `DELETE /users/me` con el mismo formato de respuesta que el resto de la API (`status: true`) o `204`.
  Future<bool> deleteAccount() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      final response = await http
          .delete(
            Uri.parse(ApiConfig.getDeleteAccountUrl()),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 204) {
        await logout();
        return true;
      }

      if (response.statusCode == 200) {
        if (response.body.isEmpty || response.body.trim().isEmpty) {
          await logout();
          return true;
        }
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data['status'] == true) {
          await logout();
          return true;
        }
      }

      print('❌ Borrar cuenta: ${response.statusCode} ${response.body}');
      return false;
    } catch (e) {
      print('❌ Error al borrar cuenta: $e');
      return false;
    }
  }


  Future<Map<String, dynamic>?> uploadProfileImage(File imageFile) async {
  final token = await getToken();
  if (token == null) return null;

  try {
    final url = Uri.parse(ApiConfig.getUploadProfileImageUrl());


    final bytes = await imageFile.readAsBytes();


    String mimeType = _getMimeType(imageFile.path);

    final request = http.MultipartRequest('PATCH', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        http.MultipartFile.fromBytes(
          'profileImage',
          bytes,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );

    print('📤 Subiendo imagen de perfil (MIME: $mimeType)');
    // API call
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        final updatedUser = data['data'];
        final prefs = await _prefs;
        if (updatedUser['profileImage'] != null) {
          await prefs.setString(AppConstants.prefUserProfileImage, updatedUser['profileImage']);
        }
        print('✅ Imagen de perfil actualizada correctamente');
        return updatedUser;
      }
    } else {
      print('❌ Error al subir imagen: ${response.statusCode}');
      print('❌ Response: ${response.body}');
    }
    return null;
  } catch (e) {
    print('❌ Error al subir imagen: $e');
    return null;
  }
}


String _getMimeType(String path) {
  final ext = path.split('.').last.toLowerCase();
  switch (ext) {
    case 'jpg': case 'jpeg': return 'image/jpeg';
    case 'png': return 'image/png';
    case 'webp': return 'image/webp';
    case 'heic': return 'image/heic';
    default: return 'application/octet-stream';
  }
}

  Future<Map<String, dynamic>?> deleteProfileImage() async {
  final token = await getToken();
  if (token == null) return null;

  try {
    // API call
    final response = await http.delete(
      Uri.parse(ApiConfig.getDeleteProfileImageUrl()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        final updatedUser = data['data'];


        final prefs = await _prefs;
        await prefs.remove(AppConstants.prefUserProfileImage);

        print('✅ Imagen de perfil eliminada correctamente');
        return updatedUser;
      }
    } else if (response.statusCode == 404) {
      print('⚠️ Endpoint para eliminar imagen no encontrado. Asegúrate de que el backend esté actualizado.');
    }

    print('❌ Error al eliminar imagen: ${response.statusCode}');
    return null;
  } catch (e) {
    print('❌ Error al eliminar imagen: $e');
    return null;
  }
}


  Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(_tokenKey);
    await prefs.remove(AppConstants.prefUserEmail);
    await prefs.remove(AppConstants.prefUserName);
    await prefs.remove(AppConstants.prefUserId);
    await prefs.remove(AppConstants.prefUserPhone);
    await prefs.remove(AppConstants.prefUserBD);
    await prefs.remove(AppConstants.prefUserProfileImage);
    await prefs.setBool(AppConstants.prefIsLoggedIn, false);
    print('👋 Sesión cerrada');
  }
}


