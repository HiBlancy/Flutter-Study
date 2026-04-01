import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/beauty_product.dart';
import 'auth_service.dart';
import 'api_config.dart';

class ProductService {
  final AuthService _authService = AuthService();

  Future<List<BeautyProduct>> getProducts({String? listType}) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return [];

      final url = Uri.parse(ApiConfig.getProductsUrl());
      final finalUrl = listType != null 
          ? Uri.parse('${ApiConfig.getProductsUrl()}?listType=$listType')
          : url;

      final response = await http.get(
        finalUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final List<dynamic> productsJson = data['data'];
          return productsJson
              .map((json) => BeautyProduct.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('❌ Error obteniendo productos: $e');
      return [];
    }
  }

  Future<BeautyProduct?> createProduct(Map<String, dynamic> productData) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      final response = await http.post(
        Uri.parse(ApiConfig.getProductsUrl()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(productData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return BeautyProduct.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error creando producto: $e');
      return null;
    }
  }

  Future<BeautyProduct?> updateProduct(String id, Map<String, dynamic> productData) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      final response = await http.patch(
        Uri.parse('${ApiConfig.getProductsUrl()}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(productData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return BeautyProduct.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error actualizando producto: $e');
      return null;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse('${ApiConfig.getProductsUrl()}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error eliminando producto: $e');
      return false;
    }
  }

  Future<BeautyProduct?> moveProduct(String id, String targetList) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      final response = await http.patch(
        Uri.parse('${ApiConfig.getProductsUrl()}/$id/move'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'targetList': targetList}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return BeautyProduct.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error moviendo producto: $e');
      return null;
    }
  }
}