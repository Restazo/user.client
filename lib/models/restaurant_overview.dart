import 'package:restazo_user_mobile/models/menu_category.dart';
import 'package:restazo_user_mobile/models/restaurant_address.dart';

class RestaurantOverview {
  const RestaurantOverview({
    required this.address,
    required this.affordability,
    required this.coverImage,
    required this.description,
    required this.id,
    required this.logoImage,
    required this.name,
    required this.menu,
  });

  final String id;
  final String name;
  final String? description;
  final int affordability;
  final String? logoImage;
  final String? coverImage;
  final RestaurantAddress address;
  final List<MenuCategory> menu;

  factory RestaurantOverview.fromJson(
      Map<String, dynamic> restaurantOverviewDataJson) {
    final menuJson = restaurantOverviewDataJson['menu'];
    final addressJson = restaurantOverviewDataJson['address'];

    final List<MenuCategory> menuData = menuJson
        .map<MenuCategory>(
            (menuCategoryJson) => MenuCategory.fromJson(menuCategoryJson))
        .toList();

    final RestaurantAddress addressData =
        RestaurantAddress.fromJson(addressJson);

    return RestaurantOverview(
      id: restaurantOverviewDataJson['id']!,
      name: restaurantOverviewDataJson['name']!,
      description: restaurantOverviewDataJson['description'],
      affordability: restaurantOverviewDataJson['affordability']!,
      logoImage: restaurantOverviewDataJson['logoImage'],
      coverImage: restaurantOverviewDataJson['coverImage'],
      address: addressData,
      menu: menuData,
    );
  }
}
