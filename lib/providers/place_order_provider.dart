import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/models/menu_item.dart';

import 'package:restazo_user_mobile/models/order_menu_item.dart';

class PlaceOrderNotifier extends StateNotifier<List<OrderMenuItem>> {
  PlaceOrderNotifier() : super([]);

  void addMenuItemToOrder(MenuItem itemDataToUpdate,
      {int incrementAmount = 1}) {
    final bool itemExists =
        state.any((element) => element.itemData.id == itemDataToUpdate.id);

    if (itemExists) {
      state = state.map((item) {
        if (item.itemData.id == itemDataToUpdate.id) {
          return OrderMenuItem(
              itemData: item.itemData,
              itemAmount: item.itemAmount + incrementAmount);
        }

        return item;
      }).toList();
    } else {
      state = [
        ...state,
        OrderMenuItem(itemData: itemDataToUpdate, itemAmount: incrementAmount)
      ];
    }
  }

  void removeMenuItemFromOrder(MenuItem itemDataToUpdate,
      {int removeAmount = 1}) {
    final bool itemExists =
        state.any((element) => element.itemData.id == itemDataToUpdate.id);

    if (itemExists) {
      List<OrderMenuItem> updatedState = [];

      for (var item in state) {
        if (item.itemData.id == itemDataToUpdate.id) {
          int newItemAmount = item.itemAmount - removeAmount;
          if (newItemAmount > 0) {
            updatedState.add(OrderMenuItem(
                itemData: item.itemData, itemAmount: newItemAmount));
          }
        } else {
          updatedState.add(item);
        }
      }

      state = updatedState;
    }
  }

  void deleteOrderData() {
    state = [];
  }
}

final placeOrderProvider =
    StateNotifierProvider<PlaceOrderNotifier, List<OrderMenuItem>>(
        (ref) => PlaceOrderNotifier());
