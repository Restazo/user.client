import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/models/restaurant_overview.dart';

class RestaurantOverviewState extends APIServiceResult<RestaurantOverview> {
  const RestaurantOverviewState(
      {super.data, super.errorMessage, this.initialRestaurantData});

  final RestaurantNearYou? initialRestaurantData;
}
