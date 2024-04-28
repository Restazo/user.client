import 'package:flutter/material.dart';

import 'package:restazo_user_mobile/models/menu_category.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/widgets/categories_scroller.dart';
import 'package:restazo_user_mobile/widgets/menu_items_list.dart';

class RestaurantOverviewMenuSection extends StatefulWidget {
  const RestaurantOverviewMenuSection({super.key, required this.menu});

  final List<MenuCategory> menu;

  @override
  State<RestaurantOverviewMenuSection> createState() =>
      _RestaurantOverviewMenuSectionState();
}

class _RestaurantOverviewMenuSectionState
    extends State<RestaurantOverviewMenuSection> {
  int activeCategoryIndex = 0;

  late List<Widget> categoryWidgets;

  @override
  void initState() {
    super.initState();
    categoryWidgets = widget.menu.map((category) {
      return KeyedSubtree(
        key: PageStorageKey<String>(category.categoryId),
        child: MenuItemsList(
          navigateTo: ScreenNames.menuItemDetail.name,
          menuItemsList: category.categoryItems,
        ),
      );
    }).toList();
  }

  void onSelectCategory(int index) {
    setState(() {
      activeCategoryIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeCategoryWidget = categoryWidgets[activeCategoryIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: [
            CategoriesScroller(
              menu: widget.menu,
              activeCategoryIndex: activeCategoryIndex,
              onselectCategory: onSelectCategory,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: activeCategoryWidget,
              ),
            ),
          ],
        )
      ],
    );
  }
}
