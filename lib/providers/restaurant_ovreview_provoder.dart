import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/models/restaurant_overview.dart';

class RestaurantOverviewState extends APIServiceResult<RestaurantOverview> {
  const RestaurantOverviewState(
      {super.data, super.errorMessage, this.initialRestaurantData});

  final RestaurantNearYou? initialRestaurantData;
}

class RestaurantOverviewNotifier
    extends StateNotifier<RestaurantOverviewState> {
  RestaurantOverviewNotifier()
      : super(const RestaurantOverviewState(
          data: null,
          errorMessage: null,
          initialRestaurantData: null,
        ));

  Future<void> loadRestaurantOverviewById(
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

  void enterRestaurantOverviewScreen(RestaurantNearYou initialRestaurantData) {
    state = RestaurantOverviewState(
        initialRestaurantData: initialRestaurantData,
        data: null,
        errorMessage: null);
  }

  void leaveRestaurantOverviewScreen() {
    state = const RestaurantOverviewState(
      data: null,
      errorMessage: null,
      initialRestaurantData: null,
    );
  }
}

final restaurantOverviewProvider =
    StateNotifierProvider<RestaurantOverviewNotifier, RestaurantOverviewState>(
        (ref) => RestaurantOverviewNotifier());
