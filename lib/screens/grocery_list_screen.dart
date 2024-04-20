import 'package:flutter/material.dart';
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
  final List<GroceryModel> groceryModelList = [];

  void _onAddNewItemPressed(BuildContext context) {
    Navigator.of(context).push<GroceryModel>(
      MaterialPageRoute(builder: (context) {
        return const NewGroceryItemScreen();
      }),
    ).then((model) {
      if (model != null) {
        setState(() {
          groceryModelList.add(model);
        });
      }
    });
  }

  void _onRemoveItem(GroceryModel model) {
    setState(() {
      groceryModelList.remove(model);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Item avilable'),
    );

    if (groceryModelList.isNotEmpty) {
      content = ListView.builder(
          itemCount: groceryModelList.length,
          itemBuilder: (context, index) {
            final gorceryModel = groceryModelList[index];
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
                  color: gorceryModel.category.color,
                ),
                trailing: Text(
                  gorceryModel.quantity.toString(),
                ),
              ),
            );
          });
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
