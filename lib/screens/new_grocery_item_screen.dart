import 'package:flutter/material.dart';
import 'package:shopping_list/data/available_categories.dart';
import 'package:shopping_list/models/category_model.dart';
import 'package:shopping_list/models/grocery_model.dart';

class NewGroceryItemScreen extends StatefulWidget {
  const NewGroceryItemScreen({super.key});

  @override
  State<NewGroceryItemScreen> createState() {
    return _NewGroceryItemScreenState();
  }
}

class _NewGroceryItemScreenState extends State<NewGroceryItemScreen> {
  String? _name;
  String _quanity = '1';
  Category? _category = availavleCategories[CategoryType.vegetables];
  final _formKey = GlobalKey<FormState>();

  void _onResetPressed() {
    _formKey.currentState?.reset();
  }

  void _onSaveItemPressed() {
    final isValidated = _formKey.currentState?.validate() ?? false;
    if (isValidated) {
      _formKey.currentState?.save();
      print('name: $_name');
      print('quantity: $_quanity');
      print(_category?.type);
      Navigator.of(context).pop(GroceryModel(
        id: DateTime.now().toString(),
        name: _name!,
        quantity: int.parse(_quanity),
        category: _category!,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  String? errorMessage;
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length >= 50) {
                    errorMessage = 'Value must be between 0 and 5 chracters';
                  }
                  return errorMessage;
                },
                onSaved: (newValue) {
                  _name = newValue;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: _quanity,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        String? errorMessage;
                        if (value == null ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! < 1) {
                          errorMessage = 'Value must be a positive integer';
                        }
                        return errorMessage;
                      },
                      onSaved: ((newValue) => _quanity = newValue!),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      value: _category,
                      items: availavleCategories.entries
                          .map(
                            (entry) => DropdownMenuItem(
                              value: entry.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    color: entry.value.color,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(entry.value.name),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        _category = value;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _onResetPressed,
                    child: const Text('Reset'),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: _onSaveItemPressed,
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
