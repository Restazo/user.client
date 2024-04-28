import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/models/restaurant_overview.dart';

class RestaurantOverviewState extends APIServiceResult<RestaurantOverview> {
  const RestaurantOverviewState(
      {required super.data,
      required super.errorMessage,
      required this.initialRestaurantData});

  final RestaurantNearYou? initialRestaurantData;
}
