import 'package:restazo_user_mobile/models/order_menu_item.dart';

class Requests {
  const Requests({required this.pendingOrders, required this.waiterRequests});

  final List<WaiterRequest> waiterRequests;
  final List<PendingOrder> pendingOrders;

  factory Requests.fromJson(Map<String, dynamic> requests) {
    final waiterRequestsRaw = requests['requests'] as List<dynamic>;
    final pendingOrdersRaw = requests['orders'] as List<dynamic>;

    final processedWaiterRequests =
        waiterRequestsRaw.map((e) => WaiterRequest.fromJson(e)).toList();
    final processedPendingOrders =
        pendingOrdersRaw.map((e) => PendingOrder.fromJson(e)).toList();

    return Requests(
      waiterRequests: processedWaiterRequests,
      pendingOrders: processedPendingOrders,
    );
  }
}

class WaiterRequest {
  const WaiterRequest(
      {required this.createdAt,
      required this.requestType,
      required this.tableId,
      required this.tableLabel});

  final String tableId;
  final String tableLabel;
  final String requestType;
  final int createdAt;

  factory WaiterRequest.fromJson(Map<String, dynamic> json) {
    return WaiterRequest(
      createdAt: json['createdAt'],
      requestType: json['requestType'],
      tableId: json['tableId'],
      tableLabel: json['tableLabel'],
    );
  }
}

class PendingOrder {
  const PendingOrder({
    required this.deviceId,
    required this.orderId,
    required this.orderItems,
    required this.tableId,
    required this.tableLabel,
    required this.createdAt,
  });

  final String orderId;
  final String tableId;
  final String deviceId;
  final String tableLabel;
  final List<OrderProcessingMenuItem> orderItems;
  final int createdAt;

  factory PendingOrder.fromJson(Map<String, dynamic> json) {
    final orderItemsJson = json['orderItems'] as List<dynamic>;

    final orderItems =
        orderItemsJson.map((e) => OrderProcessingMenuItem.fromJson(e)).toList();

    return PendingOrder(
      orderId: json['orderId'],
      deviceId: json['deviceId'],
      orderItems: orderItems,
      tableId: json['tableId'],
      tableLabel: json['tableLabel'],
      createdAt: json['createdAt'],
    );
  }
}
