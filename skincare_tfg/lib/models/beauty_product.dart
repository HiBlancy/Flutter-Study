// lib/models/beauty_product.dart
class BeautyProduct {
  // Campos básicos (para búsqueda externa)
  final String barcode;
  final String name;
  final String brand;
  final String? imageUrl;
  final List<String> categories;
  
  // Campos adicionales (para productos guardados en tu backend)
  final String? id;
  final String? notes;
  final int? rating;
  final String? listType;
  final DateTime? expirationDate;
  final String? periodAfterOpening;
  final DateTime? openedDate;
  final DateTime? addedAt;

  const BeautyProduct({
    required this.barcode,
    required this.name,
    required this.brand,
    this.imageUrl,
    this.categories = const [],
    this.id,
    this.notes,
    this.rating,
    this.listType,
    this.expirationDate,
    this.periodAfterOpening,
    this.openedDate,
    this.addedAt,
  });

  // Factory para productos desde Open Beauty Facts (API externa)
  factory BeautyProduct.fromOpenBeautyFacts(Map<String, dynamic> json) {
    final rawCategories = json['categories_tags'] as List<dynamic>? ?? [];

    return BeautyProduct(
      barcode: json['code']?.toString() ?? '',
      name: json['product_name']?.toString().trim() ?? '',
      brand: json['brands']?.toString().trim() ?? '',
      imageUrl: json['image_front_small_url']?.toString() ??
                json['image_front_url']?.toString(),
      categories: rawCategories
          .map((c) => c.toString().replaceAll('en:', '').replaceAll('-', ' '))
          .toList(),
    );
  }

  // Factory para productos desde tu backend
  factory BeautyProduct.fromBackend(Map<String, dynamic> json) {
    final rawCategories = json['categories'] as List<dynamic>? ?? [];
    
    return BeautyProduct(
      id: json['_id']?.toString(),
      barcode: json['barcode']?.toString() ?? '',
      name: json['name']?.toString().trim() ?? '',
      brand: json['brand']?.toString().trim() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      categories: rawCategories
          .map((c) => c.toString().replaceAll('en:', '').replaceAll('-', ' '))
          .toList(),
      notes: json['notes']?.toString(),
      rating: json['rating'] as int?,
      listType: json['listType']?.toString(),
      expirationDate: json['expirationDate'] != null 
          ? DateTime.parse(json['expirationDate']) 
          : null,
      periodAfterOpening: json['periodAfterOpening']?.toString(),
      openedDate: json['openedDate'] != null 
          ? DateTime.parse(json['openedDate']) 
          : null,
      addedAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  // Convertir a formato para enviar a tu backend
  Map<String, dynamic> toBackendJson() {
    return {
      'name': name,
      'brand': brand,
      'barcode': barcode,
      'imageUrl': imageUrl,
      'categories': categories,
      'notes': notes,
      'rating': rating,
      'listType': listType ?? 'have',
      'expirationDate': expirationDate?.toIso8601String(),
      'periodAfterOpening': periodAfterOpening,
      'openedDate': openedDate?.toIso8601String(),
    };
  }

  // Crear una copia con campos actualizados
  BeautyProduct copyWith({
    String? barcode,
    String? name,
    String? brand,
    String? imageUrl,
    List<String>? categories,
    String? id,
    String? notes,
    int? rating,
    String? listType,
    DateTime? expirationDate,
    String? periodAfterOpening,
    DateTime? openedDate,
    DateTime? addedAt,
  }) {
    return BeautyProduct(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      id: id ?? this.id,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      listType: listType ?? this.listType,
      expirationDate: expirationDate ?? this.expirationDate,
      periodAfterOpening: periodAfterOpening ?? this.periodAfterOpening,
      openedDate: openedDate ?? this.openedDate,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}