import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/models/mark_order.dart';

class MarkTableOrdersState extends APIServiceResult<MarkTableOrders> {
  const MarkTableOrdersState(
      {required super.data, required super.errorMessage});
}
