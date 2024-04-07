import 'package:restazo_user_mobile/models/menu_item.dart';

class MenuCategory {
  const MenuCategory({
    required this.categoryId,
    required this.categoryLabel,
    required this.categoryItems,
  });

  final String categoryId;
  final String categoryLabel;
  final List<MenuItem> categoryItems;

  factory MenuCategory.fromJson(Map<String, dynamic> menuCategoryJson) {
    final List<dynamic> categoryItemsJson = menuCategoryJson['categoryItems'];

    final List<MenuItem> categoryItems = categoryItemsJson
        .map((menuItemJson) => MenuItem.fromJson(menuItemJson))
        .toList();

    return MenuCategory(
      categoryId: menuCategoryJson['categoryId']!,
      categoryLabel: menuCategoryJson['categoryLabel']!,
      categoryItems: categoryItems,
    );
  }
}
