import 'package:flutter/material.dart';

enum ProductListType {
  have('have', 'Tengo', Icons.check_circle_outline, Colors.green),
  wishlist('wishlist', 'Deseados', Icons.favorite_border, Colors.pink),
  used('used', 'Terminados', Icons.history, Colors.blue);

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const ProductListType(this.value, this.label, this.icon, this.color);

  static ProductListType fromValue(String value) {
    try {
      return values.firstWhere((type) => type.value == value);
    } catch (e) {
      return have;
    }
  }

  static ProductListType fromNullable(String? value) {
    if (value == null || value.isEmpty) {
      return have;
    }
    return fromValue(value);
  }
}