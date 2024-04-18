import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_grocery_models.dart';
import 'package:shopping_list/screens/new_grocery_item_screen.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});
  void _onAddNewItemPressed(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const NewGroceryItemScreen();
    }));
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
      body: ListView.builder(
          itemCount: groceryModels.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(groceryModels[index].name),
              leading: Container(
                height: 24,
                width: 24,
                color: groceryModels[index].category.color,
              ),
              trailing: Text(
                groceryModels[index].quantity.toString(),
              ),
            );
          }),
    );
  }
}
