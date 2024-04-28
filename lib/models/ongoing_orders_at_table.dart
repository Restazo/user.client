import 'package:restazo_user_mobile/models/order_menu_item.dart';

class OngoingOrder {
  const OngoingOrder(
      {required this.tableId,
      required this.tableLabel,
      required this.tableItems});

  final String tableId;
  final String tableLabel;
  final List<OrderProcessingMenuItem> tableItems;

  factory OngoingOrder.fromJson(Map<String, dynamic> tableOrdersJson) {
    final tableOrders = tableOrdersJson['orders'] as List<dynamic>;

    Map<String, OrderProcessingMenuItem> itemMap = {};
    for (var order in tableOrders) {
      List<OrderProcessingMenuItem> items =
          (order['orderItems'] as List<dynamic>)
              .map((item) => OrderProcessingMenuItem.fromJson(item))
              .toList();

      for (var item in items) {
        if (itemMap.containsKey(item.itemId)) {
          itemMap[item.itemId] = OrderProcessingMenuItem(
            itemId: item.itemId,
            itemName: item.itemName,
            itemAmount: itemMap[item.itemId]!.itemAmount + item.itemAmount,
          );
        } else {
          itemMap[item.itemId] = item;
        }
      }
    }

    return OngoingOrder(
      tableId: tableOrdersJson['tableId'],
      tableLabel: tableOrdersJson['tableLabel'],
      tableItems: itemMap.values.toList(),
    );
  }
}
