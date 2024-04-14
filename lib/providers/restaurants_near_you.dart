import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/helpers/get_current_location.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';

// State for the notifier, with this state class
// we can determine whether
class RestaurantsNearYouState
    extends APIServiceResult<List<RestaurantNearYou>> {
  // Constructor function that passes arguments to the
  // APIServiceResult class
  const RestaurantsNearYouState({
    super.data,
    super.errorMessage,
    // this.changedRange,
  });

  // final bool? changedRange;
}

class RestaurantsNearYouNotifier
    extends StateNotifier<RestaurantsNearYouState> {
  RestaurantsNearYouNotifier()
      : super(
          const RestaurantsNearYouState(
            data: [],
            errorMessage: null,
          ),
        );

  Future<void> loadRestaurantsNearYou() async {
    try {
      final currentLocation = await getCurrentLocation();
      final RestaurantsNearYouState result =
          await APIService().loadRestaurantsNearYou(currentLocation);

      state = result;
    } catch (e) {
      state = const RestaurantsNearYouState(
          data: [], errorMessage: "Something unexpected happened");
    }
  }
}

final restaurantsNearYouProvider =
    StateNotifierProvider<RestaurantsNearYouNotifier, RestaurantsNearYouState>(
        (ref) => RestaurantsNearYouNotifier());
