import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/models/grocery_model.dart';
import 'package:shopping_list/providers/grocery_item_provider.dart';
import 'package:shopping_list/screens/new_grocery_item_screen.dart';

class GroceryListScreen extends ConsumerStatefulWidget {
  const GroceryListScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _GroceryListScreenState();
  }
}

class _GroceryListScreenState extends ConsumerState<GroceryListScreen> {
  List<GroceryModel> _groceryModelList = [];
  bool _isLoading = true;
  String? _errorMessage;

  void _onAddNewItemPressed(BuildContext context) {
    Navigator.of(context).push<GroceryModel>(
      MaterialPageRoute(builder: (context) {
        return const NewGroceryItemScreen();
      }),
    ).then((model) {
      if (model != null) {
        ref.read(gorceryItemProvider.notifier).addGroceryModel(model);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(gorceryItemProvider.notifier).getGroceryItems().whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _groceryModelList = ref.watch(gorceryItemProvider);
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
                ref
                    .read(gorceryItemProvider.notifier)
                    .deleteGroceryItem(gorceryModel);
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
