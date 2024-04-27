import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/api_result_states/restaurant_overview_state.dart';

class TableSessionRestaurantNotifier
    extends StateNotifier<RestaurantOverviewState> {
  TableSessionRestaurantNotifier()
      : super(const RestaurantOverviewState(
          data: null,
          errorMessage: null,
          initialRestaurantData: null,
        ));

  Future<void> loadRestaurantById(
      String restaurantId, LocationData? currentLocation) async {
    try {
      final RestaurantOverviewState result = await APIService()
          .loadRestaurantOverviewById(restaurantId, currentLocation);

      state = RestaurantOverviewState(
        initialRestaurantData: state.initialRestaurantData,
        data: result.data,
        errorMessage: result.errorMessage,
      );
    } catch (e) {
      state = const RestaurantOverviewState(
        initialRestaurantData: null,
        data: null,
        errorMessage: 'Something unexpected happened',
      );
    }
  }

  void deleteRestaurantData() {
    state = const RestaurantOverviewState(
      data: null,
      errorMessage: null,
      initialRestaurantData: null,
    );
  }
}

final tableSessionRestaurantProvider = StateNotifierProvider<
    TableSessionRestaurantNotifier,
    RestaurantOverviewState>((ref) => TableSessionRestaurantNotifier());
