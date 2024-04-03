import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:restazo_user_mobile/helpers/api_result.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/menu_category.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/widgets/loaders/menu_section_loader.dart';
import 'package:restazo_user_mobile/widgets/menu_section.dart';
import 'package:restazo_user_mobile/widgets/restaurant_overview_images.dart';
import 'package:restazo_user_mobile/widgets/restaurant_text_info.dart';
import 'package:restazo_user_mobile/widgets/snack_bar.dart';

class RestaurantOverviewMenuState extends APIServiceResult<List<MenuCategory>> {
  // Constructor function that passes arguments to the
  // APIServiceResult class
  const RestaurantOverviewMenuState({super.data, super.errorMessage});
}

class RestaurantOverviewScreen extends StatefulWidget {
  const RestaurantOverviewScreen({super.key, required this.restaurantInitData});

  final RestaurantNearYou restaurantInitData;

  @override
  State<RestaurantOverviewScreen> createState() =>
      _RestaurantOverviewScreenState();
}

class _RestaurantOverviewScreenState extends State<RestaurantOverviewScreen>
    with TickerProviderStateMixin {
  // Initialize the menu state with an empty array
  late RestaurantOverviewMenuState menuState =
      const RestaurantOverviewMenuState(data: []);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRestaurantMenuData();
  }

  Future<void> _loadRestaurantMenuData() async {
    setState(() {
      _isLoading = true;
    });

    final RestaurantOverviewMenuState result =
        await APIService().loadMenuByRestaurantId(widget.restaurantInitData.id);

    if (!result.isSuccess) {
      if (mounted) {
        setState(() {
          menuState = RestaurantOverviewMenuState(
              data: [], errorMessage: result.errorMessage);
          _isLoading = false;
        });
      }
      return;
    }

    // Check if the widget tree is mounted
    // if it is not we need to omit setting new state
    // as user might leave the screen earlier and "dispose"
    // will be called earlier
    if (mounted) {
      setState(() {
        menuState =
            RestaurantOverviewMenuState(data: result.data, errorMessage: null);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget menuSectionWidget;

    if (_isLoading) {
      menuSectionWidget = const KeyedSubtree(
        key: ValueKey("restaurant_overview_menu_loader"),
        child: MenuSectionLoader(),
      );
    } else if (menuState.isSuccess && menuState.data!.isNotEmpty) {
      menuSectionWidget = KeyedSubtree(
        key: const ValueKey("restaurant_overview_menu_data"),
        child: RestaurantOverviewMenuSection(menu: menuState.data!),
      );
    } else {
      menuSectionWidget = Center(
        child: Text(
          "No menu",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
              ),
        ),
      );
    }

    // Show snackbar on error
    if (menuState.errorMessage != null && !_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .clearSnackBars(); // Clear existing snackbars first
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWithAction.create(
            content: Text(
              menuState.errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
            actionFunction: _loadRestaurantMenuData,
            actionLabel: "Reload"));
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: AppBar(
              scrolledUnderElevation: 0.0,
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
              leading: IconButton(
                splashColor: Theme.of(context).splashColor,
                highlightColor: Theme.of(context).highlightColor,
                // iconSize: 28,
                icon: Image.asset(
                  'assets/left.png',
                  width: 28,
                  height: 28,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  context.pop();
                },
              ),
              actions: [
                IconButton(
                  splashColor: Theme.of(context).splashColor,
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
            RestaurantOverviewImages(
              coverImage: widget.restaurantInitData.coverImage,
              logoImage:
                  //  TODO: replace with the actual logo
                  'https://images.unsplash.com/photo-1568376794508-ae52c6ab3929?q=80&w=2000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ),
            RestaurantOverviewTextInfo(
                restaurantInfo: widget.restaurantInitData),
            AnimatedSize(
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
                child: menuSectionWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
