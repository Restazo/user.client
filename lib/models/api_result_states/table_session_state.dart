import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/models/table_session.dart';

class TableSessionState extends APIServiceResult<TableSession> {
  const TableSessionState(
      {required super.data,
      required super.errorMessage,
      required this.sessionMessage});

  final String? sessionMessage;
}
