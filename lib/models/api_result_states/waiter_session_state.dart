import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/models/waiter_session.dart';

class WaiterSessionState extends APIServiceResult<WaiterSession> {
  const WaiterSessionState(
      {super.data, super.errorMessage, this.sessionMessage});

  final String? sessionMessage;
}
