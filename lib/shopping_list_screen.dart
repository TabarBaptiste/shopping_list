import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shopping_list_provider.dart';
import 'shopping_item.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

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
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                    if (_nameController.text.isNotEmpty &&
                        _categoryController.text.isNotEmpty) {
                      shoppingListProvider.addItem(
                          _nameController.text, _categoryController.text);
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
            child: ListView.builder(
              itemCount: shoppingListProvider.itemsByCategory.length,
              itemBuilder: (context, index) {
                final entry = shoppingListProvider.itemsByCategory.entries
                    .elementAt(index);
                return _buildCategorySection(
                    entry.key, entry.value, shoppingListProvider);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category, List<ShoppingItem> items,
      ShoppingListProvider provider) {
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
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                provider.removeItem(
                    item); // Supprimer l'article lorsque le glissement est terminé
              },
              child: ListTile(
                title: Text(
                  item.name,
                  style: TextStyle(
                    color: item.isActive ? Colors.black : Colors.grey,
                    decoration: item.isActive
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
                onTap: () {
                  provider.toggleItem(item);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
