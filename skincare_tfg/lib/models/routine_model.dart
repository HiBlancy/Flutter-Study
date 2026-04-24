// lib/models/routine.dart

enum RoutineType { morning, night }

class RoutineProduct {
  final String productId;
  final int order;
  final Map<String, dynamic>? productData; // populated product info

  RoutineProduct({
    required this.productId,
    required this.order,
    this.productData,
  });

  factory RoutineProduct.fromJson(Map<String, dynamic> json) {
    // productId can be a string or a populated object
    final productIdField = json['productId'];
    String id;
    Map<String, dynamic>? data;

    if (productIdField is Map<String, dynamic>) {
      id = productIdField['_id'] ?? '';
      data = productIdField;
    } else {
      id = productIdField?.toString() ?? '';
    }

    return RoutineProduct(
      productId: id,
      order: json['order'] ?? 0,
      productData: data,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'order': order,
      };

  String get name => productData?['name'] ?? 'Producto';
  String get brand => productData?['brand'] ?? '';
  String? get imageUrl => productData?['imageUrl'];
}

class Routine {
  final String? id;
  final String name;
  final RoutineType type;
  final List<String> days; // ['monday', 'tuesday', ...]
  final List<RoutineProduct> products;
  final DateTime? createdAt;

  Routine({
    this.id,
    required this.name,
    required this.type,
    required this.days,
    this.products = const [],
    this.createdAt,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type']?.toString() ?? 'morning';
    return Routine(
      id: json['_id']?.toString(),
      name: json['name'] ?? '',
      // Verifica que esta línea esté correcta:
      type: typeStr == 'night' ? RoutineType.night : RoutineType.morning,
      days: List<String>.from(json['days'] ?? []),
      products: (json['products'] as List<dynamic>? ?? [])
          .map((p) => RoutineProduct.fromJson(p as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order)),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type == RoutineType.morning ? 'morning' : 'night',
        'days': days,
        'products': products.map((p) => p.toJson()).toList(),
      };

  Routine copyWith({
    String? id,
    String? name,
    RoutineType? type,
    List<String>? days,
    List<RoutineProduct>? products,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      days: days ?? this.days,
      products: products ?? this.products,
      createdAt: createdAt,
    );
  }
}