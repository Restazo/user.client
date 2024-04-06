import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/models/menu_item.dart';

class MenuItemState extends APIServiceResult<MenuItem> {
  const MenuItemState({
    super.data,
    super.errorMessage,
    this.initailMenuItemData,
  });

  final MenuItem? initailMenuItemData;
}

class MenuItemNotifier extends StateNotifier<MenuItemState> {
  MenuItemNotifier()
      : super(const MenuItemState(
          initailMenuItemData: null,
          data: null,
          errorMessage: null,
        ));
  // If we develop the endpoint to fetch menu item data, make a method to load it here

  void enterRestaurantOverviewScreen(MenuItem initailMenuItemData) {
    state = MenuItemState(
        initailMenuItemData: initailMenuItemData,
        data: null,
        errorMessage: null);
  }

  void leaveRestaurantOverviewScreen() {
    state = const MenuItemState(
      data: null,
      errorMessage: null,
      initailMenuItemData: null,
    );
  }
}

final menuItemProvider = StateNotifierProvider<MenuItemNotifier, MenuItemState>(
    (ref) => MenuItemNotifier());
