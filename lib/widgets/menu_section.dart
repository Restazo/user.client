import 'package:flutter/material.dart';

import 'package:restazo_user_mobile/models/menu_category.dart';
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

  Widget buildCategoryWidget() {
    return Stack(
      children: List.generate(categoryWidgets.length, (index) {
        return Visibility(
          visible: index == activeCategoryIndex,
          child: categoryWidgets[index],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activeCategoryWidget = categoryWidgets[activeCategoryIndex];

    return Column(
      children: [
        CategoriesScroller(
          menu: widget.menu,
          activeCategoryIndex: activeCategoryIndex,
          onselectCategory: onSelectCategory,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: activeCategoryWidget,
          ),
        ),
      ],
    );
  }
}
