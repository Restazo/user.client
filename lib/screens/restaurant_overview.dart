import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:restazo_user_mobile/dummy/menu.dart';
import 'package:restazo_user_mobile/widgets/categories_scroller.dart';
import 'package:restazo_user_mobile/widgets/menu_items_list.dart';
import 'package:restazo_user_mobile/widgets/restaurant_overview_images.dart';
import 'package:restazo_user_mobile/widgets/restaurant_text_info.dart';

class RestaurantOverviewScreen extends StatefulWidget {
  const RestaurantOverviewScreen({super.key});

  @override
  State<RestaurantOverviewScreen> createState() =>
      _RestaurantOverviewScreenState();
}

class _RestaurantOverviewScreenState extends State<RestaurantOverviewScreen> {
  int activeCategoryIndex = 0;
  // //////////////////////////////////
  // final List<AnimationController> _fadeAnimationControllers = [];
  // final List<Animation<double>> _fadeAnimations = [];

  // @override
  // void initState() {
  //   super.initState();
  //   for (var i = 0; i < menu.length; i++) {
  //     final controller = AnimationController(
  //       duration: const Duration(milliseconds: 300),
  //       vsync: this,
  //     );
  //     final animation =
  //         CurvedAnimation(parent: controller, curve: Curves.easeInOut);
  //     _fadeAnimationControllers.add(controller);
  //     _fadeAnimations.add(animation);

  //     if (i == activeCategoryIndex) {
  //       controller.value = 1.0; // Initially show the first item
  //     }
  //   }
  // }

  // @override
  // void dispose() {
  //   for (var controller in _fadeAnimationControllers) {
  //     controller.dispose();
  //   }
  //   super.dispose();
  // }

  // void onSelectCategory(int index) {
  //   setState(() {
  //     // Fade out the currently active category
  //     _fadeAnimationControllers[activeCategoryIndex].reverse();
  //     // Fade in the new active category
  //     activeCategoryIndex = index;
  //     _fadeAnimationControllers[activeCategoryIndex].forward();
  //   });
  // }

  // List<Widget> _categoryItemsWidgets() {
  //   return List.generate(
  //     menu.length,
  //     (index) => FadeTransition(
  //       opacity: _fadeAnimations[index],
  //       child: MenuItemsList(
  //         key: ValueKey<String>(menu[index].categoryId),
  //         menuItemsList: menu[index].categoryItems,
  //       ),
  //     ),
  //   );
  // }

  // ///////////////////////////////////////////////

  void onSelectCategory(int index) {
    setState(() {
      activeCategoryIndex = index;
    });
  }

  List<MenuItemsList> get _categoryItems {
    return List.generate(
      menu.length,
      (index) => MenuItemsList(
        menuItemsList: menu[index].categoryItems,
      ),
    );
  }

  // List<Widget> _categoryItemsWidgets() {
  //   return List.generate(
  //     menu.length,
  //     (index) => Opacity(
  //       opacity: activeCategoryIndex == index ? 1.0 : 0.0,
  //       child: MenuItemsList(
  //         key: ValueKey<String>(menu[index].categoryId), // Unique key
  //         menuItemsList: menu[index].categoryItems,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // var categoryWidgets = _categoryItemsWidgets();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          // Clip the widget to only apply effects within its bounds
          child: BackdropFilter(
            // Apply a filter to the background content
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), // Blur effect
            child: AppBar(
              scrolledUnderElevation: 0.0,
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
              actions: [
                IconButton(
                  highlightColor: Theme.of(context).highlightColor,
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/qr-code-scan.png',
                    width: 28,
                    height: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
        child: ListView(
          children: [
            const RestaurantOverviewImages(
              coverImage:
                  'https://images.unsplash.com/photo-1571162242324-f1607b1eceaa?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              logoImage:
                  'https://images.unsplash.com/photo-1568376794508-ae52c6ab3929?q=80&w=2000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ),
            const RestaurantOverviewTextInfo(),
            CategoriesScroller(
              menu: menu,
              activeCategoryIndex: activeCategoryIndex,
              onselectCategory: onSelectCategory,
            ),
            IndexedStack(
              index: activeCategoryIndex,
              children: _categoryItems,
            )
            // AnimatedSwitcher(
            //   duration: const Duration(milliseconds: 300),
            //   transitionBuilder: (Widget child, Animation<double> animation) {
            //     return FadeTransition(
            //       opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
            //       child: child,
            //     );
            //   },
            //   child: Stack(
            //     children: categoryWidgets,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
