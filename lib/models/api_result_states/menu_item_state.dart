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
