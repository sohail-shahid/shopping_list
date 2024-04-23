import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:shopping_list/models/grocery_model.dart';

class GroceryItemProvider extends StateNotifier<List<GroceryModel>> {
  GroceryItemProvider() : super([]);
  Future<void> getGroceryItems() async {
    Uri url = Uri.https(
        'shoppinglist-e0988-default-rtdb.firebaseio.com', 'shopping_list.json');
    final response = await get(url);
    print(response.body);

    if (response.statusCode >= 400) {
      throw Exception('Failed to load data please try later.');
    } else if (response.body == 'null') {
      state = [];
    } else {
      final List<GroceryModel> groceryItems = [];
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      for (final entry in decodedResponse.entries) {
        entry.value['id'] = entry.key;
        final GroceryModel modelFromJson = GroceryModel.fromJson(entry.value);
        groceryItems.add(modelFromJson);
      }
      state = groceryItems;
    }
  }

  void addGroceryModel(GroceryModel model) {
    state = [...state, model];
  }

  // Future<void> addGroceryModel(
  //   String name,
  //   int quanity,
  //   Category category,
  // ) async {
  //   final url = Uri.https(
  //       'shoppinglist-e0988-default-rtdb.firebaseio.com', 'shopping_list.json');
  //   final response = await post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(
  //       {
  //         'name': name,
  //         'quantity': quanity,
  //         'category_name': category.name,
  //       },
  //     ),
  //   );
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     GroceryModel? model;
  //     Map<String, dynamic> decodedResponse = json.decode(response.body);
  //     model = GroceryModel(
  //       id: decodedResponse['name']!,
  //       name: name,
  //       quantity: quanity,
  //       category: category,
  //     );
  //     state = [...state, model];
  //   }
  // }

  void deleteGroceryItem(GroceryModel model) async {
    final olderState = state;
    state = state
        .where(
          (element) => element.id != model.id,
        )
        .toList();

    Uri url = Uri.https('shoppinglist-e0988-default-rtdb.firebaseio.com',
        'shopping_list/${model.id}.json');
    final response = await delete(url);
    print(response.body);
    if (response.statusCode >= 400) {
      state = olderState;
    }
  }
}

final gorceryItemProvider =
    StateNotifierProvider<GroceryItemProvider, List<GroceryModel>>(
  (ref) => GroceryItemProvider(),
);
