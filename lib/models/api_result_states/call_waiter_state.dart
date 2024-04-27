import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/models/call_waiter.dart';

class CallWaiterState extends APIServiceResult<CallWaiter> {
  const CallWaiterState({required super.data, required super.errorMessage});
}
