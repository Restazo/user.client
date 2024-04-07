import 'package:flutter/material.dart';

import 'package:restazo_user_mobile/models/menu_category.dart';
import 'package:restazo_user_mobile/widgets/category_button.dart';

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller({
    super.key,
    required this.menu,
    required this.activeCategoryIndex,
    required this.onselectCategory,
  });

  final List<MenuCategory> menu;
  final int activeCategoryIndex;
  final void Function(int) onselectCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            spreadRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: menu.length,
          itemBuilder: (context, index) {
            final isActive = index == activeCategoryIndex;
            final isLast = index == menu.length - 1;
            final isFirst = index == 0;
            final categoryLabel = menu[index].categoryLabel;

            return MenuCategoryButton(
              isActive: isActive,
              isLast: isLast,
              isFirst: isFirst,
              categoryLabel: categoryLabel,
              index: index,
              onSelectCategory: onselectCategory,
            );
          },
        ),
      ),
    );
  }
}
