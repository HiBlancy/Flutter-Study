// lib/models/beauty_product.dart
class BeautyProduct {
  final String barcode;
  final String name;
  final String brand;
  final String? imageUrl;
  final List<String> categories;
  final String? notes;
  final int? rating;
  final String listType;
  final DateTime? expirationDate;
  final String? periodAfterOpening;
  final DateTime? openedDate;
  final DateTime addedAt;

  const BeautyProduct({
    required this.barcode,
    required this.name,
    required this.brand,
    this.imageUrl,
    this.categories = const [],
    this.notes,
    this.rating,
    this.listType = 'have',
    this.expirationDate,
    this.periodAfterOpening,
    this.openedDate,
    required this.addedAt,
  });

  factory BeautyProduct.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['categories'] as List<dynamic>? ?? [];
    
    return BeautyProduct(
      barcode: json['barcode']?.toString() ?? '',
      name: json['name']?.toString().trim() ?? '',
      brand: json['brand']?.toString().trim() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      categories: rawCategories
          .map((c) => c.toString().replaceAll('en:', '').replaceAll('-', ' '))
          .toList(),
      notes: json['notes']?.toString(),
      rating: json['rating'] as int?,
      listType: json['listType']?.toString() ?? 'have',
      expirationDate: json['expirationDate'] != null 
          ? DateTime.parse(json['expirationDate']) 
          : null,
      periodAfterOpening: json['periodAfterOpening']?.toString(),
      openedDate: json['openedDate'] != null 
          ? DateTime.parse(json['openedDate']) 
          : null,
      addedAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'barcode': barcode,
      'imageUrl': imageUrl,
      'categories': categories,
      'notes': notes,
      'rating': rating,
      'listType': listType,
      'expirationDate': expirationDate?.toIso8601String(),
      'periodAfterOpening': periodAfterOpening,
      'openedDate': openedDate?.toIso8601String(),
    };
  }
}