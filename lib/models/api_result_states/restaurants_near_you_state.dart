import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';

class RestaurantsNearYouState
    extends APIServiceResult<List<RestaurantNearYou>> {
  // Constructor function that passes arguments to the
  // APIServiceResult class
  const RestaurantsNearYouState({
    super.data,
    super.errorMessage,
  });
}
