import 'package:shopping_list/models/category_model.dart';
import 'package:shopping_list/models/grocery_model.dart';
import 'package:shopping_list/data/available_categories.dart';

var groceryModels = [
  GroceryModel(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: availavleCategories[CategoryType.dairy]!),
  GroceryModel(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: availavleCategories[CategoryType.fruit]!),
  GroceryModel(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: availavleCategories[CategoryType.meat]!),
];
