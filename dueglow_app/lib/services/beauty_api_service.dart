
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/beauty_product.dart';

class BeautySearchResult {
  final List<BeautyProduct> products;
  final int page;
  final int pageSize;
  final int totalCount;

  const BeautySearchResult({
    required this.products,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  bool get hasMore {
    if (products.isEmpty) return false;
    if (totalCount > 0) return page * pageSize < totalCount;
    return products.length >= pageSize;
  }
}

class BeautyApiService {
  static const String _baseUrl = 'https://world.openbeautyfacts.org';
  static const int searchPageSize = 20;

  static Future<BeautySearchResult> searchProducts(
    String query, {
    int page = 1,
    int pageSize = searchPageSize,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/cgi/search.pl'
      '?search_terms=${Uri.encodeComponent(query)}'
      '&search_simple=1'
      '&action=process'
      '&json=1'
      '&page=$page'
      '&page_size=$pageSize'
      '&fields=code,product_name,brands,image_front_small_url,categories_tags',
    );

    final response = await http.get(uri, headers: {'User-Agent': 'SkincareApp/1.0'});

    if (response.statusCode != 200) throw Exception('Error ${response.statusCode}');

    final data = json.decode(response.body);
    final products = data['products'] as List<dynamic>? ?? [];
    final totalCount = (data['count'] as num?)?.toInt() ?? 0;
    final currentPage = (data['page'] as num?)?.toInt() ?? page;

    final parsed = products
        .map((p) => BeautyProduct.fromOpenBeautyFacts(p))
        .where((p) => p.name.isNotEmpty)
        .toList();

    return BeautySearchResult(
      products: parsed,
      page: currentPage,
      pageSize: pageSize,
      totalCount: totalCount,
    );
  }

  static Future<BeautyProduct?> getProductByBarcode(String barcode) async {
    final uri = Uri.parse(
      '$_baseUrl/api/v2/product/$barcode.json'
      '?fields=code,product_name,brands,image_front_url,categories_tags,ingredients_text',
    );

    final response = await http.get(uri, headers: {'User-Agent': 'SkincareApp/1.0'});

    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    if (data['status'] != 1) return null;

    return BeautyProduct.fromOpenBeautyFacts(data['product']);
  }
}