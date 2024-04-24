import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/api_result_states/restaurants_near_you_state.dart';
import 'package:restazo_user_mobile/providers/user_location_data_provider.dart';

class RestaurantsNearYouNotifier
    extends StateNotifier<RestaurantsNearYouState> {
  RestaurantsNearYouNotifier(this.ref)
      : super(
          const RestaurantsNearYouState(
            data: [],
            errorMessage: null,
          ),
        );

  final Ref ref;

  Future<void> loadRestaurantsNearYou() async {
    try {
      final currentLocation = ref.read(userLocationDataProvider);

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
        (ref) => RestaurantsNearYouNotifier(ref));
