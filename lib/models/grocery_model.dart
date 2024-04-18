import 'package:shopping_list/models/category_model.dart';

class GroceryModel {
  const GroceryModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });
  final String id;
  final String name;
  final int quantity;
  final Category category;
}
