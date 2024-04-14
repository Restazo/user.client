import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
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

  Future<void> loadMenuItemData(String itemId, String restaurantId) async {
    try {
      final result = await APIService().loadMenuItemById(restaurantId, itemId);

      state = MenuItemState(
          initailMenuItemData: state.initailMenuItemData,
          data: result.data,
          errorMessage: result.errorMessage);
    } catch (e) {
      state = const MenuItemState(
          initailMenuItemData: null,
          data: null,
          errorMessage: 'Something unexpected happened');
    }
  }

  void enterMenuItemScreen(MenuItem initailMenuItemData) {
    state = MenuItemState(
        initailMenuItemData: initailMenuItemData,
        data: null,
        errorMessage: null);
  }

  void leaveMenuItemScreen() {
    state = const MenuItemState(
      data: null,
      errorMessage: null,
      initailMenuItemData: null,
    );
  }
}

final menuItemProvider = StateNotifierProvider<MenuItemNotifier, MenuItemState>(
    (ref) => MenuItemNotifier());
