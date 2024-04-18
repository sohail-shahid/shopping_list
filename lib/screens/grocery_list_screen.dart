import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_grocery_models.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries List'),
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
