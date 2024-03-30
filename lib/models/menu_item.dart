class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.price,
    // required this.priceCurrency,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String ingredients;
  final String price;
  // final String priceCurrency;
}
