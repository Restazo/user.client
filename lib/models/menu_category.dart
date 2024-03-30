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
}
