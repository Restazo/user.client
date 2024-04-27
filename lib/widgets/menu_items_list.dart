import 'package:flutter/material.dart';

import 'package:restazo_user_mobile/models/menu_item.dart';
import 'package:restazo_user_mobile/widgets/menu_item.dart';

class MenuItemsList extends StatefulWidget {
  const MenuItemsList({
    super.key,
    required this.menuItemsList,
    required this.navigateTo,
  });

  final String navigateTo;
  final List<MenuItem> menuItemsList;

  @override
  State<MenuItemsList> createState() => _MenuItemsListState();
}

class _MenuItemsListState extends State<MenuItemsList> {
  @override
  Widget build(BuildContext context) {
    Map<String, MenuItem> menuItemMap = {};

    for (final menuItem in widget.menuItemsList) {
      menuItemMap[menuItem.id] =
          menuItem; // This will overwrite any existing entry with the same ID
    }

    List<MenuItem> uniqueMenuItems = menuItemMap.values.toList();

    return Column(
      children: [
        for (final menuItem in uniqueMenuItems)
          MenuItemCard(
              key: ValueKey(menuItem.id),
              itemData: menuItem,
              navigateTo: widget.navigateTo)
      ],
    );
  }
}
