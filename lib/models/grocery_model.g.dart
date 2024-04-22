// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroceryModel _$GroceryModelFromJson(Map<String, dynamic> json) => GroceryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      categoryName: json['category_name'] as String?,
    );

Map<String, dynamic> _$GroceryModelToJson(GroceryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'category_name': instance.categoryName,
    };
