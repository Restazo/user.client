import 'package:flutter/material.dart';

import 'package:restazo_user_mobile/dummy/menu.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/categories_scroller.dart';
import 'package:restazo_user_mobile/widgets/menu_items_list.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  int activeCategoryIndex = 0;

  late List<Widget> categoryWidgets;

  @override
  void initState() {
    super.initState();

    categoryWidgets = menu.map((category) {
      return KeyedSubtree(
        key: PageStorageKey<String>(category.categoryId),
        child: MenuItemsList(
          navigateTo: ScreenNames.orderMenuItemDetail.name,
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

  void _goBack() {
    navigateBack(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget activeCategoryWidget = categoryWidgets[activeCategoryIndex];

// ErrorScreenWithAction(
//         buttonLabel: "Reload menu",
//         errorMessage: "Something very bad happened",
//         buttonAction: () {},
//         baseMessageWidget: Center(
//           child: Text(
//             "No menu found",
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                   color: Colors.white,
//                 ),
//           ),
//         ),
//       ),

    return Scaffold(
      appBar: RestazoAppBar(
        leftNavigationIconAction: _goBack,
        leftNavigationIconAsset: 'assets/left.png',
        title: Strings.placeOrderTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 64, bottom: 72),
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: activeCategoryWidget,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 4, 15, 18),
                          const Color.fromARGB(255, 4, 15, 18)
                              .withOpacity(0.67),
                          const Color.fromARGB(0, 4, 15, 18),
                        ],
                        stops: const [0.0, 0.8, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    height: 72,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CategoriesScroller(
                        menu: menu,
                        activeCategoryIndex: activeCategoryIndex,
                        onselectCategory: onSelectCategory,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.75),
                          blurRadius: 24,
                          spreadRadius: 24,
                        )
                      ]),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromARGB(255, 200, 200, 200);
                              }
                              return null;
                            },
                          ),
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            Strings.reviewOrderTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.black,
                                ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
