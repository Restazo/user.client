import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';

class RestaurantsNearYouState {
  RestaurantsNearYouState({this.restaurants, this.error});

  final List<RestaurantNearYou>? restaurants;
  final String? error;
}

class RestaurantsNearYouNotifier
    extends StateNotifier<RestaurantsNearYouState> {
  RestaurantsNearYouNotifier()
      : super(RestaurantsNearYouState(restaurants: const [], error: null));

  Future<void> loadRestaurantsNearYou(LocationData? locationData) async {
    try {
      List<RestaurantNearYou>? restaurants =
          await APIService().loadRestaurantsNearYou(locationData);

      await Future.delayed(Duration(seconds: 2));

      if (restaurants == null) throw Exception('Failed to load restaurants');

      state = RestaurantsNearYouState(restaurants: restaurants, error: null);
    } catch (e) {
      state =
          RestaurantsNearYouState(restaurants: const [], error: e.toString());
    }
  }
}

final restaurantsNearYouProvider =
    StateNotifierProvider<RestaurantsNearYouNotifier, RestaurantsNearYouState>(
        (ref) => RestaurantsNearYouNotifier());
