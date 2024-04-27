import 'package:restazo_user_mobile/models/menu_item.dart';

class OrderMenuItem {
  const OrderMenuItem({
    required this.itemData,
    required this.itemAmount,
  });

  final MenuItem itemData;
  final int itemAmount;
}

class OrderProcessingMenuItem {
  const OrderProcessingMenuItem({
    required this.itemId,
    required this.itemName,
    required this.itemAmount,
  });

  final String itemName;
  final String itemId;
  final int itemAmount;
}
