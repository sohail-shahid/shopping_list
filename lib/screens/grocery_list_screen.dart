import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopping_list/data/available_categories.dart';
import 'package:shopping_list/models/grocery_model.dart';
import 'package:shopping_list/screens/new_grocery_item_screen.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _GroceryListScreenState();
  }
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<GroceryModel> _groceryModelList = [];
  late Future<List<GroceryModel>> _loadGroceryItemsTask;

  Future<List<GroceryModel>> _loadGroceryItems() async {
    Uri url = Uri.https(
        'shoppinglist-e0988-default-rtdb.firebaseio.com', 'shopping_list.json');
    final response = await get(url);
    print(response.body);
    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch grocery items, please try later');
    }
    if (response.body == 'null') {
      return [];
    }

    final List<GroceryModel> groceryItems = [];
    Map<String, dynamic> decodedResponse = json.decode(response.body);
    for (final entry in decodedResponse.entries) {
      final category = availavleCategories.entries.firstWhere(
          (category) => category.value.name == entry.value['category_name']);
      final GroceryModel model = GroceryModel(
        id: entry.key,
        name: entry.value['name'],
        quantity: entry.value['quantity'],
        category: category.value,
      );
      groceryItems.add(model);
    }
    return groceryItems;
  }

  void _onAddNewItemPressed(BuildContext context) {
    Navigator.of(context).push<GroceryModel>(
      MaterialPageRoute(builder: (context) {
        return const NewGroceryItemScreen();
      }),
    ).then((model) {
      if (model != null) {
        setState(() {
          _loadGroceryItemsTask = _loadGroceryItems();
        });
      }
    });
  }

  void _onRemoveItem(GroceryModel model) async {
    Uri url = Uri.https('shoppinglist-e0988-default-rtdb.firebaseio.com',
        'shopping_list/${model.id}.json');
    final response = await delete(url);
    setState(() {
      _loadGroceryItemsTask = _loadGroceryItems();
    });
    print(response.body);
  }

  @override
  void initState() {
    super.initState();
    _loadGroceryItemsTask = _loadGroceryItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries List'),
        actions: [
          IconButton(
              onPressed: () {
                _onAddNewItemPressed(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _loadGroceryItemsTask,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (snapshot.data?.isEmpty ?? true) {
            return const Center(
              child: Text('No Item avilable'),
            );
          }
          _groceryModelList = snapshot.data ?? [];
          return ListView.builder(
              itemCount: _groceryModelList.length,
              itemBuilder: (context, index) {
                final gorceryModel = _groceryModelList[index];
                return Dismissible(
                  key: ValueKey(gorceryModel.id),
                  onDismissed: (direction) {
                    _onRemoveItem(gorceryModel);
                  },
                  background:
                      Container(color: Theme.of(context).colorScheme.error),
                  direction: DismissDirection.endToStart,
                  child: ListTile(
                    title: Text(gorceryModel.name),
                    leading: Container(
                      height: 24,
                      width: 24,
                      color: gorceryModel.category.color,
                    ),
                    trailing: Text(
                      gorceryModel.quantity.toString(),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
