import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/models/ongoing_orders_at_table.dart';

class OngoingOrdersNotifier extends StateNotifier<List<OngoingOrder>> {
  OngoingOrdersNotifier() : super([]);

  Future<void> setNewOngoingOrders(List<OngoingOrder> orders) async {
    state = orders;
  }
}

final ongoingOrdersProvider =
    StateNotifierProvider<OngoingOrdersNotifier, List<OngoingOrder>>(
        (ref) => OngoingOrdersNotifier());
