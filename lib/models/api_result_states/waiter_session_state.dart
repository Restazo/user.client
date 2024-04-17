import 'package:restazo_user_mobile/helpers/api_result.dart';

class WaiterSessionState extends APIServiceResult<String> {
  const WaiterSessionState(
      {super.data, super.errorMessage, this.sessionMessage});

  final String? sessionMessage;
}
