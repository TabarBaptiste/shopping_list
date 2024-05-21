class ShoppingItem {
  final String name;
  final String category;
  final bool isActive;

  ShoppingItem({required this.name, required this.category, this.isActive = false});

  ShoppingItem copyWith({String? name, String? category, bool? isActive}) {
    return ShoppingItem(
      name: name ?? this.name,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
    );
  }
}
