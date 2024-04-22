import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  bool _isLoading = true;
  String? _errorMessage;

  void _loadGroceryItems() {
    setState(() {
      _isLoading = true;
    });
    Uri url = Uri.https(
        'shoppinglist-e0988-default-rtdb.firebaseio.com', 'shopping_list.json');
    get(url).then((response) {
      print(response.body);
      if (response.statusCode >= 400) {
        setState(() {
          _errorMessage = 'failed to fetch data please try later';
        });
        return;
      }
      _errorMessage = null;
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final List<GroceryModel> groceryItems = [];
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      for (final entry in decodedResponse.entries) {
        entry.value['id'] = entry.key;
        final GroceryModel modelFromJson = GroceryModel.fromJson(entry.value);
        groceryItems.add(modelFromJson);
      }
      setState(() {
        _isLoading = false;
        _groceryModelList = groceryItems;
      });
    });
  }

  void _onAddNewItemPressed(BuildContext context) {
    Navigator.of(context).push<GroceryModel>(
      MaterialPageRoute(builder: (context) {
        return const NewGroceryItemScreen();
      }),
    ).then((model) {
      if (model != null) {
        setState(() {
          _groceryModelList.add(model);
        });
      }
    });
  }

  void _onRemoveItem(GroceryModel model) async {
    final indexOfModel = _groceryModelList.indexOf(model);
    setState(() {
      _groceryModelList.remove(model);
    });
    Uri url = Uri.https('shoppinglist-e0988-default-rtdb.firebaseio.com',
        'shopping_list/${model.id}.json');
    final response =
        await delete(url); // deleting from backend using http package
    print(response.body);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryModelList.insert(indexOfModel, model);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadGroceryItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Text('No Item avilable'),
    );

    if (_groceryModelList.isNotEmpty) {
      content = ListView.builder(
          itemCount: _groceryModelList.length,
          itemBuilder: (context, index) {
            final gorceryModel = _groceryModelList[index];
            return Dismissible(
              key: ValueKey(gorceryModel.id),
              onDismissed: (direction) {
                _onRemoveItem(gorceryModel);
              },
              background: Container(color: Theme.of(context).colorScheme.error),
              direction: DismissDirection.endToStart,
              child: ListTile(
                title: Text(gorceryModel.name),
                leading: Container(
                  height: 24,
                  width: 24,
                  color: gorceryModel.category!.color,
                ),
                trailing: Text(
                  gorceryModel.quantity.toString(),
                ),
              ),
            );
          });
    }

    if (_errorMessage != null) {
      content = Center(
        child: Text(_errorMessage!),
      );
    }
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
      body: content,
    );
  }
}
