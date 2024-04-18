import 'package:flutter/material.dart';

enum CategoryType {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
}

class Category {
  const Category(this.name, this.color, this.type);
  final String name;
  final Color color;
  final CategoryType type;
}
