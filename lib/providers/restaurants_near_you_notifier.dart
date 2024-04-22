import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/helpers/get_current_location.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/providers/restaurants_near_you.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantsNearYouNotifier extends StateNotifier<RestaurantsNearYouState> {
  RestaurantsNearYouNotifier() : super(const RestaurantsNearYouState(data: [], errorMessage: null));

  Future<void> loadRestaurantsNearYou(double searchRange) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('user_search_range_key_name', searchRange.toString());

      final currentLocation = await getCurrentLocation();
      final RestaurantsNearYouState result = await APIService().loadRestaurantsNearYou(currentLocation);

      state = result;
    } catch (e) {
      state = const RestaurantsNearYouState(data: [], errorMessage: "Something unexpected happened");
    }
  }
}

final restaurantsNearYouProvider = StateNotifierProvider<RestaurantsNearYouNotifier, RestaurantsNearYouState>(
  (ref) => RestaurantsNearYouNotifier());
