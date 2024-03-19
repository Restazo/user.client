import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:restazo_user_mobile/models/restaurant_near_you.dart';

class RestaurantsNearYouNotifier
    extends StateNotifier<List<RestaurantNearYou>> {
  RestaurantsNearYouNotifier() : super(const []);
}

final restaurantsNearYouProvider =
    StateNotifierProvider<RestaurantsNearYouNotifier, List<RestaurantNearYou>>(
        (ref) => RestaurantsNearYouNotifier());
