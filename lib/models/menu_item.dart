class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.priceAmount,
    required this.priceCurrency,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final String? description;
  final String ingredients;
  final String priceAmount;
  final String priceCurrency;

  factory MenuItem.fromJson(Map<String, dynamic> menuItemJson) {
    return MenuItem(
      id: menuItemJson['id']!,
      name: menuItemJson['name']!,
      imageUrl: menuItemJson['image'],
      description: menuItemJson['description'],
      ingredients: menuItemJson['ingredients']!,
      priceAmount: menuItemJson['priceAmount']!,
      priceCurrency: menuItemJson['priceCurrency']!,
    );
  }
}
