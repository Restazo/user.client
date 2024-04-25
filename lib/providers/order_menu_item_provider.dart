import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:restazo_user_mobile/models/menu_item.dart';

class OrderMenuItemNotifier extends StateNotifier<MenuItem?> {
  OrderMenuItemNotifier() : super(null);

  void enterOrderMenuItemScreen(MenuItem initailMenuItemData) {
    state = MenuItem(
      id: initailMenuItemData.id,
      name: initailMenuItemData.name,
      imageUrl: initailMenuItemData.imageUrl,
      description: initailMenuItemData.description,
      ingredients: initailMenuItemData.ingredients,
      priceAmount: initailMenuItemData.priceAmount,
      priceCurrency: initailMenuItemData.priceCurrency,
    );
  }

  void leaveOrderMenuItemScreen() {
    state = null;
  }
}

final orderMenuItemProvider =
    StateNotifierProvider<OrderMenuItemNotifier, MenuItem?>(
        (ref) => OrderMenuItemNotifier());
