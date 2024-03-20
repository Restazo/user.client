import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:restazo_user_mobile/dummy/dummy_restaurants_near_you.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';

class RestaurantsNearYouNotifier
    extends StateNotifier<List<RestaurantNearYou>> {
  RestaurantsNearYouNotifier() : super(const []);

  Future<void> loadRestaurantsNearYou() async {
    await Future.delayed(const Duration(seconds: 2));
    // Call an API here

    state = restaurants;
  }
}

final restaurantsNearYouProvider =
    StateNotifierProvider<RestaurantsNearYouNotifier, List<RestaurantNearYou>>(
        (ref) => RestaurantsNearYouNotifier());
