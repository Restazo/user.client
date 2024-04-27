import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/get_current_location.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_three_actions.dart';
import 'package:restazo_user_mobile/providers/place_order_provider.dart';
import 'package:restazo_user_mobile/providers/table_session_menu_provider.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/categories_scroller.dart';
import 'package:restazo_user_mobile/widgets/error_widgets/error_screen.dart';
import 'package:restazo_user_mobile/widgets/loaders/menu_section_loader.dart';
import 'package:restazo_user_mobile/widgets/menu_items_list.dart';

class PlaceOrderScreen extends ConsumerStatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  ConsumerState<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends ConsumerState<PlaceOrderScreen> {
  int activeCategoryIndex = 0;
  bool _isLoading = false;

  List<Widget>? categoryWidgets;

  void onSelectCategory(int index) {
    setState(() {
      activeCategoryIndex = index;
    });
  }

  Future<void> loadMenuData() async {
    setState(() {
      _isLoading = true;
    });
    const storage = FlutterSecureStorage();

    final restaurantId =
        await storage.read(key: tableSessionRestaurantIdKeyName);

    if (restaurantId == null) {
      if (mounted) {
        await showCupertinoDialogWithOneAction(
            context,
            Strings.unexpectedErrorTitle,
            "Something went wrong",
            Strings.ok,
            _goBack);
      }
      return;
    }

    final location = await getCurrentLocation();

    await ref
        .read(tableSessionRestaurantProvider.notifier)
        .loadRestaurantById(restaurantId, location);

    setState(() {
      _isLoading = false;
    });
  }

  void _goBack() {
    final orderState = ref.read(placeOrderProvider);

    if (orderState.isNotEmpty) {
      showCupertinoDialogWithThreeActions(
        context,
        "Save order",
        "Would you like to discard your order or save it for later?",
        "Save",
        () {
          navigateBack(context);
          navigateBack(context);
        },
        "Discard",
        () {
          ref.read(placeOrderProvider.notifier).deleteOrderData();
          navigateBack(context);
          navigateBack(context);
        },
        Strings.cancel,
        () {
          navigateBack(context);
        },
      );
    } else {
      navigateBack(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(placeOrderProvider);
    final menuState = ref.watch(tableSessionRestaurantProvider);

    Widget loader = const KeyedSubtree(
      key: ValueKey("table_session_menu_loader"),
      child: MenuSectionLoader(),
    );

    Widget content = KeyedSubtree(
      key: const ValueKey("menu_not_found_error_screen"),
      child: ErrorScreenWithAction(
        buttonLabel: "Reload menu",
        errorMessage: "Something very bad happened",
        buttonAction: loadMenuData,
        baseMessageWidget: Center(
          child: Text(
            "No menu found",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );

    if ((menuState.data == null && menuState.errorMessage == null) ||
        _isLoading) {
      content = loader;
    } else if (menuState.data != null) {
      categoryWidgets = menuState.data!.menu.map((category) {
        return KeyedSubtree(
          key: PageStorageKey<String>(category.categoryId),
          child: MenuItemsList(
            navigateTo: ScreenNames.orderMenuItemDetail.name,
            menuItemsList: category.categoryItems,
          ),
        );
      }).toList();

      Widget activeCategoryWidget = categoryWidgets![activeCategoryIndex];

      content = KeyedSubtree(
        key: const ValueKey("table_session_menu_data"),
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
                        menu: menuState.data!.menu,
                        activeCategoryIndex: activeCategoryIndex,
                        onselectCategory: onSelectCategory,
                      ),
                    ),
                  ),
                  if (orderState.isNotEmpty)
                    Positioned(
                      bottom: 24,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.75),
                            blurRadius: 24,
                            spreadRadius: 24,
                            offset: const Offset(0, 24),
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
                                  return const Color.fromARGB(
                                      255, 200, 200, 200);
                                }
                                return null;
                              },
                            ),
                          ),
                          onPressed: () {
                            context.goNamed(ScreenNames.confirmOrder.name);
                          },
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
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (menuState.errorMessage != null) {
      content = KeyedSubtree(
        key: const ValueKey("menu_not_found_error_screen"),
        child: ErrorScreenWithAction(
          buttonLabel: "Reload menu",
          errorMessage: menuState.errorMessage,
          buttonAction: loadMenuData,
          baseMessageWidget: Center(
            child: Text(
              "No menu found",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: RestazoAppBar(
        leftNavigationIconAction: _goBack,
        leftNavigationIconAsset: 'assets/left.png',
        title: Strings.placeOrderTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            layoutBuilder:
                (Widget? currentChild, List<Widget> previousChildren) {
              return Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: content,
          ),
        ),
      ),
    );
  }
}
