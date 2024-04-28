import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/models/order_id.dart';

class OrderIdState extends APIServiceResult<OrderId> {
  const OrderIdState({required super.data, required super.errorMessage});
}
