import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/models/waiter_session.dart';

class WaiterSessionState extends APIServiceResult<WaiterSession> {
  const WaiterSessionState(
      {required super.data,
      required super.errorMessage,
      required this.sessionMessage});

  final String? sessionMessage;
}
