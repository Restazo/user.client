import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/models/accept_or_decline_order.dart';

class AcceptOrDeclineOrderState extends APIServiceResult<AcceptOrDeclineOrder> {
  const AcceptOrDeclineOrderState(
      {required super.data, required super.errorMessage});
}
