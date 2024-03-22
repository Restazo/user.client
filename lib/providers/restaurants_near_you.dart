import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';

class RestaurantsNearYouState {
  final List<RestaurantNearYou>? restaurants;
  final String? error;

  RestaurantsNearYouState({this.restaurants, this.error});
}

class RestaurantsNearYouNotifier
    extends StateNotifier<RestaurantsNearYouState> {
  RestaurantsNearYouNotifier()
      : super(RestaurantsNearYouState(restaurants: const [], error: null));

  Future<void> loadRestaurantsNearYou() async {
    try {
      List<RestaurantNearYou>? restaurants =
          await APIService().loadRestaurantsNearYou();

      if (restaurants == null) throw Exception('Failed to load restaurants');

      state = RestaurantsNearYouState(restaurants: restaurants, error: null);
    } catch (e) {
      state =
          RestaurantsNearYouState(restaurants: const [], error: e.toString());
      print(e.toString());
    }
  }
}

final restaurantsNearYouProvider =
    StateNotifierProvider<RestaurantsNearYouNotifier, RestaurantsNearYouState>(
        (ref) => RestaurantsNearYouNotifier());
