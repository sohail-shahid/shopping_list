import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  bool _isSending = false;

  void _onResetPressed() {
    _formKey.currentState?.reset();
  }

  void _onSaveItemPressed() {
    final isValidated = _formKey.currentState?.validate() ?? false;
    if (isValidated) {
      setState(() {
        _isSending = true;
      });
      _formKey.currentState?.save();
      var url = Uri.https('shoppinglist-e0988-default-rtdb.firebaseio.com',
          'shopping_list.json');
      http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _name!,
            'quantity': int.parse(_quanity),
            'category_name': _category!.name,
          },
        ),
      )
          .then((response) {
        print(response.body);
        if (context.mounted) {
          GroceryModel? model;
          if (response.statusCode == 200) {
            Map<String, dynamic> decodedResponse = json.decode(response.body);
            model = GroceryModel(
              id: decodedResponse['name']!,
              name: _name!,
              quantity: int.parse(_quanity),
              category: _category!,
            );
          }
          Navigator.of(context).pop(model);
        }
      });
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
                    onPressed: _isSending ? null : _onResetPressed,
                    child: const Text('Reset'),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _onSaveItemPressed,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add Item'),
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
