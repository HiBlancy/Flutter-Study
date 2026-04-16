class BeautyProduct {
  // Campos básicos (para búsqueda externa)
  final String barcode;
  final String name;
  final String? brand;  // ✅ Cambiado a nullable
  final String? imageUrl;
  final List<String>? categories;  // ✅ Cambiado a nullable
  
  // Campos adicionales (para productos guardados en tu backend)
  final String? id;
  final String? notes;
  final int? rating;
  final String? listType;
  final DateTime? expirationDate;
  final String? periodAfterOpening;
  final DateTime? openedDate;
  final DateTime? addedAt;
  final DateTime? finishedDate;
  final bool? isOpened;

  const BeautyProduct({
    required this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    this.categories,
    this.id,
    this.notes,
    this.rating,
    this.listType,
    this.expirationDate,
    this.periodAfterOpening,
    this.openedDate,
    this.finishedDate,
    this.addedAt,
    this.isOpened,
  });

  // Factory para productos desde Open Beauty Facts (API externa)
  factory BeautyProduct.fromOpenBeautyFacts(Map<String, dynamic> json) {
    return BeautyProduct(
      barcode: json['code']?.toString() ?? '',
      name: json['product_name']?.toString().trim() ?? '',
      brand: json['brands']?.toString().trim(),
      imageUrl: json['image_front_small_url']?.toString() ?? 
                json['image_front_url']?.toString() ?? 
                json['image_url']?.toString(),
      isOpened: false,
    );
  }

  // Factory para productos desde tu backend
  factory BeautyProduct.fromBackend(Map<String, dynamic> json) {
    final rawCategories = json['categories'] as List<dynamic>?;
    
    return BeautyProduct(
      id: json['_id']?.toString(),
      barcode: json['barcode']?.toString() ?? '',
      name: json['name']?.toString().trim() ?? '',
      brand: json['brand']?.toString().trim(),
      imageUrl: json['imageUrl']?.toString(),
      categories: rawCategories?.map((c) => c.toString().replaceAll('en:', '').replaceAll('-', ' ')).toList(),
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
      isOpened: json['isOpened'] as bool?,
    );
  }

  // Convertir a formato para enviar a tu backend
  Map<String, dynamic> toBackendJson() {
    return {
      'name': name,
      'brand': brand,  // ✅ Puede ser null
      'barcode': barcode,
      'imageUrl': imageUrl,
      'categories': categories,  // ✅ Puede ser null
      'notes': notes,
      'rating': rating,
      'listType': listType ?? 'have',
      'expirationDate': expirationDate?.toIso8601String(),
      'periodAfterOpening': periodAfterOpening,
      'openedDate': openedDate?.toIso8601String(),
      'isOpened': isOpened,
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
    bool? isOpened,
  }) {
    return BeautyProduct(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brand: brand,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories,
      id: id ?? this.id,
      notes: notes,
      rating: rating,
      listType: listType ?? this.listType,
      expirationDate: expirationDate,
      periodAfterOpening: periodAfterOpening,
      openedDate: openedDate,
      addedAt: addedAt ?? this.addedAt,
      isOpened: isOpened ?? this.isOpened,
    );
  }
}

class PaginatedProducts {
  final List<BeautyProduct> products;
  final int totalProducts;
  final int totalPages;
  final int currentPage;
  final int limit;

  PaginatedProducts({
    required this.products,
    required this.totalProducts,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  factory PaginatedProducts.fromJson(Map<String, dynamic> json) {
    final data = json['data']; // El objeto que contiene {data, info}
    final List<dynamic> productsList = data['data'];
    final info = data['info'];

    return PaginatedProducts(
      products: productsList.map((p) => BeautyProduct.fromBackend(p)).toList(),
      totalProducts: info['totalProducts'],
      totalPages: info['totalPages'],
      currentPage: info['page'],
      limit: info['limit'],
    );
  }
}