import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:restazo_user_mobile/models/waiter_request.dart';

class WaiterRequestsNotifier extends StateNotifier<Requests> {
  WaiterRequestsNotifier()
      : super(const Requests(pendingOrders: [], waiterRequests: []));

  Future<void> setNewRequests(Requests requests) async {
    state = requests;
  }
}

final waiterRequestsProvider =
    StateNotifierProvider<WaiterRequestsNotifier, Requests>(
        (ref) => WaiterRequestsNotifier());
