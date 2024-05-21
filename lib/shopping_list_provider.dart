import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'shopping_item.dart';

class ShoppingListProvider with ChangeNotifier {
  final List<ShoppingItem> _items = [];

  List<ShoppingItem> get items => _items;

  Map<String, List<ShoppingItem>> get itemsByCategory {
    var categorizedItems = groupBy(_items, (ShoppingItem item) => item.category);

    categorizedItems.forEach((category, items) {
      items.sort((a, b) {
        if (a.isActive && !b.isActive) return -1;
        if (!a.isActive && b.isActive) return 1;
        return a.name.compareTo(b.name);
      });
    });

    return categorizedItems;
  }

  void addItem(String name, String category) {
    _items.add(ShoppingItem(name: name, category: category));
    notifyListeners();
  }

  void toggleItem(ShoppingItem item) {
    final index = _items.indexOf(item);
    if (index != -1) {
      _items[index] = item.copyWith(isActive: !item.isActive);
      notifyListeners();
    }
  }
}
