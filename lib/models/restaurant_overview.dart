import 'package:restazo_user_mobile/models/menu_category.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';

class RestaurantOverview {
  const RestaurantOverview({
    required this.menu,
    required this.restaurantInitData,
  });

  final RestaurantNearYou restaurantInitData;
  final List<MenuCategory>? menu;
}
