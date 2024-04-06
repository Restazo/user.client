import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/providers/menu_item_provider.dart';
import 'package:restazo_user_mobile/providers/restaurant_ovreview_provoder.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/loaders/menu_section_loader.dart';
import 'package:restazo_user_mobile/widgets/loaders/restaurant_overview_images_loader.dart';
import 'package:restazo_user_mobile/widgets/loaders/restaurant_overview_text_data_loader.dart';
import 'package:restazo_user_mobile/widgets/menu_section.dart';
import 'package:restazo_user_mobile/widgets/restaurant_overview_images.dart';
import 'package:restazo_user_mobile/widgets/restaurant_text_info.dart';
import 'package:restazo_user_mobile/widgets/snack_bar.dart';

// class RestaurantOverviewMenuState extends APIServiceResult<List<MenuCategory>> {
//   // Constructor function that passes arguments to the
//   // APIServiceResult class
//   const RestaurantOverviewMenuState({super.data, super.errorMessage});
// }

class RestaurantOverviewScreen extends ConsumerStatefulWidget {
  const RestaurantOverviewScreen({super.key});

  @override
  ConsumerState<RestaurantOverviewScreen> createState() =>
      _RestaurantOverviewScreenState();
}

class _RestaurantOverviewScreenState
    extends ConsumerState<RestaurantOverviewScreen>
    with TickerProviderStateMixin {
  // Initialize the menu state with an empty array
  // late RestaurantOverviewMenuState menuState =
  //     const RestaurantOverviewMenuState(data: [], errorMessage: null);
  bool _isLoading = false;
  bool _screenInitialised = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_screenInitialised) {
      _loadRestaurantOverview();
      _screenInitialised = true;
    }
  }

  Future<void> _loadRestaurantOverview() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    // Get the current route restaurant_id parameter
    RouteSettings settings = ModalRoute.of(context)!.settings;
    Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
    var restaurantId = arguments['restaurant_id'];

    await Future.delayed(const Duration(seconds: 2));
    // load the restaurant data into the provider
    await ref
        .read(restaurantOverviewProvider.notifier)
        .loadRestaurantOverviewById(restaurantId);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateBack() {
    navigateBack(context);
  }

  void _openQrScanner() {
    openQrScanner(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantOverviewProvider);

    List<Widget> restaurantOverviewWidgets;

    if (state.initialRestaurantData != null && _isLoading) {
      restaurantOverviewWidgets = [
        KeyedSubtree(
          key: const ValueKey('restaurant_overview_images_data'),
          child: RestaurantOverviewImages(
            coverImage: state.initialRestaurantData!.coverImage,
            logoImage: state.initialRestaurantData!.logoImage,
          ),
        ),
        KeyedSubtree(
          key: const ValueKey('restaurant_overview_text_data'),
          child: RestaurantOverviewTextInfo(
              restaurantInfo: state.initialRestaurantData!),
        ),
        const KeyedSubtree(
          key: ValueKey("restaurant_overview_menu_loader"),
          child: MenuSectionLoader(),
        )
      ];
    } else if (state.initialRestaurantData == null &&
        !_isLoading &&
        state.data != null) {
      final initialData = RestaurantNearYou(
        id: state.data!.id,
        addressLine: state.data!.address.addressLine,
        affordability: state.data!.affordability,
        coverImage: state.data!.coverImage,
        description: state.data!.description,
        name: state.data!.name,
        latitude: state.data!.address.latitude,
        longitude: state.data!.address.longitude,
        distanceKm: "5.0",
        logoImage: state.data!.logoImage,
      );

      restaurantOverviewWidgets = [
        KeyedSubtree(
          key: const ValueKey('restaurant_overview_images_data'),
          child: RestaurantOverviewImages(
            coverImage: state.data!.coverImage,
            logoImage: state.data!.logoImage,
          ),
        ),
        KeyedSubtree(
          key: const ValueKey('restaurant_overview_text_data'),
          child: RestaurantOverviewTextInfo(restaurantInfo: initialData),
        ),
        KeyedSubtree(
          key: const ValueKey("restaurant_overview_menu_data"),
          child: RestaurantOverviewMenuSection(menu: state.data!.menu),
        )
      ];
    } else if (state.initialRestaurantData != null &&
        !_isLoading &&
        state.data != null) {
      restaurantOverviewWidgets = [
        KeyedSubtree(
          key: const ValueKey('restaurant_overview_images_data'),
          child: RestaurantOverviewImages(
            coverImage: state.initialRestaurantData!.coverImage,
            logoImage: state.initialRestaurantData!.logoImage,
          ),
        ),
        KeyedSubtree(
          key: const ValueKey('restaurant_overview_text_data'),
          child: RestaurantOverviewTextInfo(
              restaurantInfo: state.initialRestaurantData!),
        ),
        KeyedSubtree(
          key: const ValueKey("restaurant_overview_menu_data"),
          child: RestaurantOverviewMenuSection(menu: state.data!.menu),
        )
      ];
    } else if (_isLoading &&
        state.initialRestaurantData == null &&
        state.data == null) {
      restaurantOverviewWidgets = [
        const KeyedSubtree(
          key: ValueKey("restaurant_overview_images_loader"),
          child: RestaurntOverViewImagesLoader(),
        ),
        const KeyedSubtree(
          key: ValueKey("restaurant_overview_text_loader"),
          child: RestaurantOverviewTextDataLoader(),
        ),
        const KeyedSubtree(
          key: ValueKey("restaurant_overview_menu_loader"),
          child: MenuSectionLoader(),
        )
      ];
    } else {
      restaurantOverviewWidgets = [
        Center(
          child: Text(
            "No restaurant found",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
        )
      ];
    }

    // If initialData exists, render top part as always
    // otherwise render loaders on loading
    // If loaded, overviewData is not null and initialData is not null, represent menu only from overviewData
    // if loaded, overviewData is not null and no initialData, repersent everything from overviewData

    // Widget menuSectionWidget;

    // if (_isLoading) {
    //   menuSectionWidget = const KeyedSubtree(
    //     key: ValueKey("restaurant_overview_menu_loader"),
    //     child: MenuSectionLoader(),
    //   );
    // } else if (menuState.isSuccess && menuState.data!.isNotEmpty) {
    //   menuSectionWidget = KeyedSubtree(
    //     key: const ValueKey("restaurant_overview_menu_data"),
    //     child: RestaurantOverviewMenuSection(menu: menuState.data!),
    //   );
    // } else {
    //   menuSectionWidget = Center(
    //     child: Text(
    //       "No menu found",
    //       style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    //             color: Colors.white,
    //           ),
    //     ),
    //   );
    // }

    // Show snackbar on error
    if (state.errorMessage != null && !_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ScaffoldMessenger.of(context)
              .clearSnackBars(); // Clear existing snackbars first
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarWithAction.create(
              content: Text(
                state.errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
              actionFunction: _loadRestaurantOverview,
              actionLabel: "Reload",
            ),
          );
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultAppBar(
        leftNavigationIconAsset: 'assets/left.png',
        leftNavigationIconAction: _navigateBack,
        rightNavigationIconAsset: 'assets/qr-code-scan.png',
        rightNavigationIconAction: _openQrScanner,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
        child: ListView(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: restaurantOverviewWidgets[0],
            ),
            if (restaurantOverviewWidgets.isNotEmpty)
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
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: restaurantOverviewWidgets[1],
                ),
              ),
            if (restaurantOverviewWidgets.length >= 2)
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
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: restaurantOverviewWidgets[2],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
