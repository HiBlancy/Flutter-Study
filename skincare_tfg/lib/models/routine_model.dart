

enum RoutineType { morning, night }

RoutineType _routineTypeFromBackend(dynamic raw) {
  if (raw is Map<String, dynamic>) {
    return _routineTypeFromBackend(
      raw['type'] ??
          raw['value'] ??
          raw['key'] ??
          raw['name'] ??
          raw['moment'] ??
          raw['timeOfDay'] ??
          raw['routineType'] ??
          raw['isNight'] ??
          raw['night'] ??
          raw['isMorning'],
    );
  }
  if (raw is bool) return raw ? RoutineType.night : RoutineType.morning;
  if (raw is num) return raw.toInt() == 1 ? RoutineType.night : RoutineType.morning;
  final s = raw?.toString().trim().toLowerCase();
  if (s == null || s.isEmpty) return RoutineType.morning;
  if (s == 'true') return RoutineType.night;
  if (s == 'false') return RoutineType.morning;
  if (s == '1') return RoutineType.night;
  if (s == '0') return RoutineType.morning;
  if (s == 'night' || s == 'noche' || s == 'evening' || s == 'pm') {
    return RoutineType.night;
  }
  if (s == 'morning' || s == 'day' || s == 'dia' || s == 'mañana' || s == 'am') {
    return RoutineType.morning;
  }
  return RoutineType.morning;
}

String? _normalizeDayKey(dynamic raw) {
  if (raw == null) return null;
  final s = raw.toString().trim().toLowerCase();
  if (s.isEmpty) return null;

  const english = {
    'monday': 'monday',
    'tuesday': 'tuesday',
    'wednesday': 'wednesday',
    'thursday': 'thursday',
    'friday': 'friday',
    'saturday': 'saturday',
    'sunday': 'sunday',
  };
  final direct = english[s];
  if (direct != null) return direct;

  const shortEn = {
    'mon': 'monday',
    'tue': 'tuesday',
    'wed': 'wednesday',
    'thu': 'thursday',
    'fri': 'friday',
    'sat': 'saturday',
    'sun': 'sunday',
  };
  final se = shortEn[s];
  if (se != null) return se;

  const es = {
    'lunes': 'monday',
    'martes': 'tuesday',
    'miercoles': 'wednesday',
    'miércoles': 'wednesday',
    'jueves': 'thursday',
    'viernes': 'friday',
    'sabado': 'saturday',
    'sábado': 'saturday',
    'domingo': 'sunday',
  };
  final e = es[s];
  if (e != null) return e;

  final n = int.tryParse(s);
  if (n != null) {
    const map = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    if (n >= 0 && n <= 6) return map[n];
    if (n >= 1 && n <= 7) return map[n - 1];
  }

  return null;
}

List<String> _daysFromBackend(dynamic raw) {
  if (raw is List) {
    final normalized = raw
        .map((e) {
          if (e is Map<String, dynamic>) {
            return _normalizeDayKey(e['key'] ?? e['day'] ?? e['name'] ?? e['value']);
          }
          return _normalizeDayKey(e);
        })
        .whereType<String>()
        .toSet()
        .toList();
    normalized.sort((a, b) => a.compareTo(b));
    return normalized;
  }
  return const [];
}

class RoutineProduct {
  final String productId;
  final int order;
  final Map<String, dynamic>? productData;

  RoutineProduct({
    required this.productId,
    required this.order,
    this.productData,
  });

  factory RoutineProduct.fromJson(Map<String, dynamic> json) {

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
  final List<String> days;
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
    dynamic rawType;

    rawType = json['type'] ??
        json['routineType'] ??
        json['moment'] ??
        json['timeOfDay'] ??
        json['time'];

    if (rawType == null) {
      if (json.containsKey('isNight')) {
        rawType = json['isNight'];
      } else if (json.containsKey('night')) {
        rawType = json['night'];
      } else if (json.containsKey('isMorning')) {
        final v = json['isMorning'];
        if (v is bool) {
          rawType = !v;
        } else {
          final s = v?.toString().trim().toLowerCase();
          if (s == 'true') rawType = 'morning';
          if (s == 'false') rawType = 'night';
        }
      }
    }

    return Routine(
      id: json['_id']?.toString(),
      name: json['name'] ?? json['message'] ?? '',
      type: _routineTypeFromBackend(rawType),
      days: _daysFromBackend(
        json['days'] ??
            json['weekDays'] ??
            json['daysOfWeek'] ??
            json['scheduleDays'],
      ),
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