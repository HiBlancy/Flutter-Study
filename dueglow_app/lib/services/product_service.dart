import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/beauty_product.dart';
import 'auth_service.dart';
import 'api_config.dart';

class MonthlyStatsItem {
  final int year;
  final int month;
  final String monthName;
  final int productsUsedCount;

  const MonthlyStatsItem({
    required this.year,
    required this.month,
    required this.monthName,
    required this.productsUsedCount,
  });

  factory MonthlyStatsItem.fromJson(Map<String, dynamic> json) {
    return MonthlyStatsItem(
      year: (json['year'] as num?)?.toInt() ?? 0,
      month: (json['month'] as num?)?.toInt() ?? 0,
      monthName: (json['monthName'] as String?) ?? '',
      productsUsedCount: (json['productsUsedCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class YearlyOverviewStats {
  final String period;
  final List<MonthlyStatsItem> data;
  final int total;

  const YearlyOverviewStats({
    required this.period,
    required this.data,
    required this.total,
  });

  factory YearlyOverviewStats.empty() {
    return const YearlyOverviewStats(period: '12_months', data: [], total: 0);
  }

  factory YearlyOverviewStats.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List?)
            ?.map((e) => MonthlyStatsItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <MonthlyStatsItem>[];
    return YearlyOverviewStats(
      period: (json['period'] as String?) ?? '12_months',
      data: list,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}

class CurrentMonthStats {
  final int year;
  final int month;
  final String monthName;
  final int productsUsedCount;
  final String status;

  const CurrentMonthStats({
    required this.year,
    required this.month,
    required this.monthName,
    required this.productsUsedCount,
    required this.status,
  });

  factory CurrentMonthStats.fromJson(Map<String, dynamic> json) {
    return CurrentMonthStats(
      year: (json['year'] as num?)?.toInt() ?? 0,
      month: (json['month'] as num?)?.toInt() ?? 0,
      monthName: (json['monthName'] as String?) ?? '',
      productsUsedCount: (json['productsUsedCount'] as num?)?.toInt() ?? 0,
      status: (json['status'] as String?) ?? '',
    );
  }
}

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


      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'listType': ?listType,
      };

      final uri = Uri.parse(
        ApiConfig.getProductsUrl(),
      ).replace(queryParameters: queryParams);

      // API call
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

      // API call
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

      // API call
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

      // API call
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


Future<List<BeautyProduct>> getExpiringSoon({int days = 30}) async {
  try {
    final token = await _authService.getToken();
    if (token == null) return [];

    // API call
    final response = await http.get(
      Uri.parse(ApiConfig.getExpiringSoonUrl(days: days)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);


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

Future<List<BeautyProduct>> getExpiredProducts() async {
  try {
    final token = await _authService.getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse(ApiConfig.getExpiredProductsUrl()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
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
    print('❌ Error en getExpiredProducts: $e');
    return [];
  }
}

  Future<BeautyProduct?> moveProduct(String id, String targetList) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      // API call
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


      final productData = <String, dynamic>{
        'name': product.name,
        'brand': product.brand,
        'listType': 'have',
      };

      if (product.barcode?.trim().isNotEmpty == true) {
        productData['barcode'] = product.barcode!.trim();
      }
      if (product.imageUrl?.trim().isNotEmpty == true) {
        productData['imageUrl'] = product.imageUrl!.trim();
      }
      if (product.categories != null && product.categories!.isNotEmpty) {
        productData['categories'] = product.categories;
      }
      if (product.notes?.trim().isNotEmpty == true) {
        productData['notes'] = product.notes!.trim();
      }
      if (product.periodAfterOpening?.trim().isNotEmpty == true) {
        productData['periodAfterOpening'] = product.periodAfterOpening!.trim();
      }
      if (product.expirationDate != null) {
        productData['expirationDate'] = product.expirationDate!.toIso8601String();
      }
      if (product.openedDate != null) {
        productData['openedDate'] = product.openedDate!.toIso8601String();
      }

      // API call
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


      final dateToSend = openedDate ?? DateTime.now();

      // API call
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

      // API call
      final response = await http.patch(
        Uri.parse('${ApiConfig.getProductsUrl()}/$id/close'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'isOpened': false,
          'openedDate': null,
          'expirationDate': null,

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

      // API call
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

    // API call
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


  Future<BeautyProduct?> deleteProductImage(String productId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      // API call
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

  Future<YearlyOverviewStats> getYearlyOverview() async {
    try {
      final token = await _authService.getToken();
      if (token == null) return YearlyOverviewStats.empty();

      final response = await http.get(
        Uri.parse(ApiConfig.getYearlyOverviewUrl()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final payload = jsonDecode(response.body);
        if (payload['status'] == true && payload['data'] != null) {
          return YearlyOverviewStats.fromJson(
            payload['data'] as Map<String, dynamic>,
          );
        }
      }
      return YearlyOverviewStats.empty();
    } catch (e) {
      print('❌ Error obteniendo yearly overview: $e');
      return YearlyOverviewStats.empty();
    }
  }

  Future<CurrentMonthStats?> getCurrentMonthStats() async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse(ApiConfig.getCurrentMonthStatsUrl()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final payload = jsonDecode(response.body);
        if (payload['status'] == true && payload['data'] != null) {
          return CurrentMonthStats.fromJson(
            payload['data'] as Map<String, dynamic>,
          );
        }
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo stats del mes actual: $e');
      return null;
    }
  }
}


