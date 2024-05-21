import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shopping_list_provider.dart';
import 'shopping_item.dart';

class ShoppingListScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste de course'),
      ),
      body: Column(
        children: [
          Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Article'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Catégorie'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_nameController.text.isNotEmpty && _categoryController.text.isNotEmpty) {
                      shoppingListProvider.addItem(_nameController.text, _categoryController.text);
                      _nameController.clear();
                      _categoryController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez remplir les deux champs'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: shoppingListProvider.itemsByCategory.entries.map((entry) {
                return _buildCategorySection(entry.key, entry.value, shoppingListProvider);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category, List<ShoppingItem> items, ShoppingListProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          title: Text(
            category,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: items.map((item) {
            return ListTile(
              title: Text(
                item.name,
                style: TextStyle(
                  color: item.isActive ? Colors.black : Colors.grey,
                  decoration: item.isActive ? TextDecoration.none : TextDecoration.lineThrough,
                ),
              ),
              onTap: () {
                provider.toggleItem(item);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
