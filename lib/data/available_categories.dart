import 'package:flutter/material.dart';

import 'package:shopping_list/models/category_model.dart';

const availavleCategories = {
  CategoryType.vegetables: Category(
    'Vegetables',
    Color.fromARGB(255, 0, 255, 128),
    CategoryType.vegetables,
  ),
  CategoryType.fruit: Category(
    'Fruit',
    Color.fromARGB(255, 145, 255, 0),
    CategoryType.fruit,
  ),
  CategoryType.meat: Category(
    'Meat',
    Color.fromARGB(255, 255, 102, 0),
    CategoryType.meat,
  ),
  CategoryType.dairy: Category(
    'Dairy',
    Color.fromARGB(255, 0, 208, 255),
    CategoryType.dairy,
  ),
  CategoryType.carbs: Category(
    'Carbs',
    Color.fromARGB(255, 0, 60, 255),
    CategoryType.carbs,
  ),
  CategoryType.sweets: Category(
    'Sweets',
    Color.fromARGB(255, 255, 149, 0),
    CategoryType.sweets,
  ),
  CategoryType.spices: Category(
    'Spices',
    Color.fromARGB(255, 255, 187, 0),
    CategoryType.spices,
  ),
  CategoryType.convenience: Category(
    'Convenience',
    Color.fromARGB(255, 191, 0, 255),
    CategoryType.convenience,
  ),
  CategoryType.hygiene: Category(
    'Hygiene',
    Color.fromARGB(255, 149, 0, 255),
    CategoryType.hygiene,
  ),
  CategoryType.other: Category(
    'Other',
    Color.fromARGB(255, 0, 225, 255),
    CategoryType.other,
  ),
};
