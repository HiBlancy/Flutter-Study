
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/beauty_product.dart';

class BeautyApiService {
  static const String _baseUrl = 'https://world.openbeautyfacts.org';


  static Future<List<BeautyProduct>> searchProducts(String query, {int page = 1}) async {
    final uri = Uri.parse(
      '$_baseUrl/cgi/search.pl'
      '?search_terms=${Uri.encodeComponent(query)}'
      '&search_simple=1'
      '&action=process'
      '&json=1'
      '&page=$page'
      '&page_size=20'
      '&fields=code,product_name,brands,image_front_small_url,categories_tags',
    );

    // API call
    final response = await http.get(uri, headers: {'User-Agent': 'SkincareApp/1.0'});

    if (response.statusCode != 200) throw Exception('Error ${response.statusCode}');

    final data = json.decode(response.body);
    final products = data['products'] as List<dynamic>? ?? [];

    return products
        .map((p) => BeautyProduct.fromOpenBeautyFacts(p))
        .where((p) => p.name.isNotEmpty)
        .toList();
  }


  static Future<BeautyProduct?> getProductByBarcode(String barcode) async {
    final uri = Uri.parse(
      '$_baseUrl/api/v2/product/$barcode.json'
      '?fields=code,product_name,brands,image_front_url,categories_tags,ingredients_text',
    );

    // API call
    final response = await http.get(uri, headers: {'User-Agent': 'SkincareApp/1.0'});

    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    if (data['status'] != 1) return null;

    return BeautyProduct.fromOpenBeautyFacts(data['product']);
  }
}