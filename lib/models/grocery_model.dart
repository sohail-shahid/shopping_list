import 'package:json_annotation/json_annotation.dart';

import 'package:shopping_list/data/available_categories.dart';
import 'package:shopping_list/models/category_model.dart';

part 'grocery_model.g.dart';

@JsonSerializable()
class GroceryModel {
  GroceryModel({
    required this.id,
    required this.name,
    required this.quantity,
    this.categoryName,
    this.category,
  });
  final String id;
  final String name;
  final int quantity;
  @JsonKey(name: 'category_name')
  String? categoryName;
  Category? category;

  factory GroceryModel.fromJson(Map<String, dynamic> json) {
    GroceryModel model = _$GroceryModelFromJson(json);
    model.category = availavleCategories.entries
        .firstWhere((category) => category.value.name == json['category_name'])
        .value;
    return model;
  }
  Map<String, dynamic> toJson() {
    return _$GroceryModelToJson(this);
  }
}
