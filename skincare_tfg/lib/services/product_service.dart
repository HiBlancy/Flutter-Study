import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/beauty_product.dart';
import 'auth_service.dart';
import 'api_config.dart';

class ProductService {
  final AuthService _authService = AuthService();

  Future<PaginatedProducts?> getProducts({
    String? listType,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      // Construir la URL con Query Parameters
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'listType': ?listType,
      };

      final uri = Uri.parse(
        ApiConfig.getProductsUrl(),
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          return PaginatedProducts.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo productos paginados: $e');
      return null;
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
          return BeautyProduct.fromBackend(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error creando producto: $e');
      return null;
    }
  }

  Future<BeautyProduct?> updateProduct(
    String id,
    Map<String, dynamic> productData,
  ) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      final Map<String, dynamic> cleanedData = {};
      productData.forEach((key, value) {
        cleanedData[key] = value;
        print('📦 Campo $key: ${value ?? 'null'}');
      });

      final response = await http.patch(
        Uri.parse('${ApiConfig.getProductsUrl()}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(cleanedData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return BeautyProduct.fromBackend(data['data']);
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

 // Obtener productos próximos a caducar
Future<List<BeautyProduct>> getExpiringSoon({int days = 30}) async {
  try {
    final token = await _authService.getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse(ApiConfig.getExpiringSoonUrl(days: days)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // ✅ Ahora accedemos a data['data']['products']
      if (data['status'] == true && data['data'] != null) {
        final productsList = data['data']['products'] as List?;
        if (productsList != null) {
          return productsList
              .map((json) => BeautyProduct.fromBackend(json))
              .toList();
        }
      }
    }
    return [];
  } catch (e) {
    print('❌ Error en getExpiringSoon: $e');
    return [];
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
          return BeautyProduct.fromBackend(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error moviendo producto: $e');
      return null;
    }
  }

  Future<BeautyProduct?> addProductToHave(BeautyProduct product) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      // Preparar los datos para el backend
      final productData = {
        'name': product.name,
        'brand': product.brand,
        'barcode': product.barcode,
        'imageUrl': product.imageUrl,
        'categories': product.categories,
        'listType': 'have', // Forzamos a "have"
      };

      final response = await http.post(
        Uri.parse(ApiConfig.getProductsUrl()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(productData),
      );

      print('📡 Add product response: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return BeautyProduct.fromBackend(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error agregando producto: $e');
      return null;
    }
  }

  Future<BeautyProduct?> markAsOpened(String id, {DateTime? openedDate}) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      // Si no se proporciona fecha, usar la fecha actual
      final dateToSend = openedDate ?? DateTime.now();

      final response = await http.patch(
        Uri.parse('${ApiConfig.getProductsUrl()}/$id/open'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'openedDate': dateToSend.toIso8601String()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return BeautyProduct.fromBackend(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error marcando como abierto: $e');
      return null;
    }
  }

  Future<BeautyProduct?> markAsClosed(String id) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      final response = await http.patch(
        Uri.parse('${ApiConfig.getProductsUrl()}/$id/close'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'isOpened': false,
          'openedDate': null, // Limpiar fecha de apertura
          'expirationDate': null, // Limpiar fecha de caducidad calculada
          // NOTA: NO tocamos periodAfterOpening, se conserva
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return BeautyProduct.fromBackend(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error marcando como cerrado: $e');
      return null;
    }
  }

  Future<BeautyProduct?> calculateExpiration(String id) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      final response = await http.post(
        Uri.parse('${ApiConfig.getProductsUrl()}/$id/calculate-expiration'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return BeautyProduct.fromBackend(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error calculando caducidad: $e');
      return null;
    }
  }

  // 🆕 Subir imagen de producto
  Future<BeautyProduct?> uploadProductImage(String productId, File imageFile) async {
  try {
    final token = await _authService.getToken();
    if (token == null) return null;

    final bytes = await imageFile.readAsBytes();
    
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.getProductsUrl()}/$productId/upload-image'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      http.MultipartFile.fromBytes(
        'productImage',
        bytes,
        filename: 'product_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

     if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] != null) {
        return BeautyProduct.fromBackend(data['data']);
      }
    }
    print('❌ Error subiendo imagen: ${response.statusCode} - ${response.body}');
    return null;
  } catch (e) {
    print('❌ Error en uploadProductImage: $e');
    return null;
  }
}

  // 🆕 Eliminar imagen de producto
  Future<BeautyProduct?> deleteProductImage(String productId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      final response = await http.delete(
        Uri.parse('${ApiConfig.getProductsUrl()}/$productId/image'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          return BeautyProduct.fromBackend(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error eliminando imagen: $e');
      return null;
    }
  }
}
