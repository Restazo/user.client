import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import 'package:restazo_user_mobile/helpers/get_current_location.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/providers/restaurant_ovreview_provoder.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/error_widgets/error_screen.dart';
import 'package:restazo_user_mobile/widgets/loaders/menu_section_loader.dart';
import 'package:restazo_user_mobile/widgets/loaders/restaurant_overview_images_loader.dart';
import 'package:restazo_user_mobile/widgets/loaders/restaurant_overview_text_data_loader.dart';
import 'package:restazo_user_mobile/widgets/menu_section.dart';
import 'package:restazo_user_mobile/widgets/restaurant_overview_images.dart';
import 'package:restazo_user_mobile/widgets/restaurant_text_info.dart';

class RestaurantOverviewScreen extends ConsumerStatefulWidget {
  const RestaurantOverviewScreen({super.key});

  @override
  ConsumerState<RestaurantOverviewScreen> createState() =>
      _RestaurantOverviewScreenState();
}

class _RestaurantOverviewScreenState
    extends ConsumerState<RestaurantOverviewScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _screenInitialised = false;
  late Future<void> _loadRestaurantOverviewFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_screenInitialised) {
      _loadRestaurantOverviewFuture = _loadRestaurantOverview();
      _screenInitialised = true;
    }
  }

  @override
  void dispose() {
    _loadRestaurantOverviewFuture.ignore();
    super.dispose();
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

    LocationData? currentLocation;

    final restaurantOverviewState = ref.watch(restaurantOverviewProvider);

    if (restaurantOverviewState.initialRestaurantData == null) {
      currentLocation = await getCurrentLocation();
    }

    // load the restaurant data into the provider
    await ref
        .read(restaurantOverviewProvider.notifier)
        .loadRestaurantOverviewById(restaurantId, currentLocation);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearRestaurantOverviewProvider() {
    ref
        .read(restaurantOverviewProvider.notifier)
        .leaveRestaurantOverviewScreen();
  }

  void _navigateBack() {
    _clearRestaurantOverviewProvider();
    navigateBack(context);
  }

  void _openQrScanner() {
    _clearRestaurantOverviewProvider();
    openQrScanner(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantOverviewProvider);

    Widget? menuSectionWidget;
    Widget? textSectionWidget;
    Widget? imagesSectionWidget;
    Widget content;

    Widget noRestaurantFound = Center(
      child: Text(
        "No restaurant found",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.white),
      ),
    );
    Widget noMenuFound = Center(
      child: Text(
        "No menu found",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.white),
      ),
    );
    Widget imagesLoader = const KeyedSubtree(
      key: ValueKey("restaurant_overview_images_loader"),
      child: RestaurntOverViewImagesLoader(),
    );
    Widget textContentLoader = const KeyedSubtree(
      key: ValueKey("restaurant_overview_text_loader"),
      child: RestaurantOverviewTextDataLoader(),
    );
    Widget menuSectionLoader = const KeyedSubtree(
      key: ValueKey("restaurant_overview_menu_loader"),
      child: MenuSectionLoader(),
    );

    if (_isLoading &&
        state.initialRestaurantData == null &&
        state.data == null) {
      // Show all the loaders if no data is present and it is loading
      imagesSectionWidget = imagesLoader;
      textSectionWidget = textContentLoader;
      menuSectionWidget = menuSectionLoader;
    } else if (state.initialRestaurantData != null &&
        _isLoading &&
        state.data == null) {
      // If Inital data is present, it is loading and to full data available
      // Represent Images and text from the initail data and show the loader for the menu
      imagesSectionWidget = KeyedSubtree(
        key: const ValueKey('restaurant_overview_images_data'),
        child: RestaurantOverviewImages(
          coverImage: state.initialRestaurantData!.coverImage,
          logoImage: state.initialRestaurantData!.logoImage,
        ),
      );
      textSectionWidget = KeyedSubtree(
        key: const ValueKey('restaurant_overview_text_data'),
        child: RestaurantOverviewTextInfo(
            restaurantInfo: state.initialRestaurantData!),
      );
      menuSectionWidget = menuSectionLoader;
    } else if (state.initialRestaurantData != null &&
        !_isLoading &&
        state.data == null) {
      // Hadle case when inital data is present but bad response from the server
      imagesSectionWidget = KeyedSubtree(
        key: const ValueKey('restaurant_overview_images_data'),
        child: RestaurantOverviewImages(
          coverImage: state.initialRestaurantData!.coverImage,
          logoImage: state.initialRestaurantData!.logoImage,
        ),
      );
      textSectionWidget = KeyedSubtree(
        key: const ValueKey('restaurant_overview_text_data'),
        child: RestaurantOverviewTextInfo(
            restaurantInfo: state.initialRestaurantData!),
      );
      menuSectionWidget = noMenuFound;
    } else if (state.initialRestaurantData == null &&
        !_isLoading &&
        state.data != null) {
      // If it is not loading, no initial data passed to the screen and
      // full data is not null, represent all the data from the full loaded data
      final initialData = RestaurantNearYou(
        id: state.data!.id,
        addressLine: state.data!.address.addressLine,
        affordability: state.data!.affordability,
        coverImage: state.data!.coverImage,
        description: state.data!.description,
        name: state.data!.name,
        latitude: state.data!.address.latitude,
        longitude: state.data!.address.longitude,
        distanceKm: state.data!.address.distanceKm,
        logoImage: state.data!.logoImage,
      );

      imagesSectionWidget = KeyedSubtree(
        key: const ValueKey('restaurant_overview_images_data'),
        child: RestaurantOverviewImages(
          coverImage: state.data!.coverImage,
          logoImage: state.data!.logoImage,
        ),
      );
      textSectionWidget = KeyedSubtree(
        key: const ValueKey('restaurant_overview_text_data'),
        child: RestaurantOverviewTextInfo(restaurantInfo: initialData),
      );
      menuSectionWidget = KeyedSubtree(
        key: const ValueKey("restaurant_overview_menu_data"),
        child: RestaurantOverviewMenuSection(menu: state.data!.menu),
      );
    } else if (state.initialRestaurantData != null &&
        !_isLoading &&
        state.data != null) {
      imagesSectionWidget = KeyedSubtree(
        key: const ValueKey('restaurant_overview_images_data'),
        child: RestaurantOverviewImages(
          coverImage: state.initialRestaurantData!.coverImage,
          logoImage: state.initialRestaurantData!.logoImage,
        ),
      );
      textSectionWidget = KeyedSubtree(
        key: const ValueKey('restaurant_overview_text_data'),
        child: RestaurantOverviewTextInfo(
            restaurantInfo: state.initialRestaurantData!),
      );
      menuSectionWidget = KeyedSubtree(
        key: const ValueKey("restaurant_overview_menu_data"),
        child: RestaurantOverviewMenuSection(menu: state.data!.menu),
      );
    }

    if (imagesSectionWidget != null &&
        textSectionWidget != null &&
        menuSectionWidget != null) {
      // Show full content if all the widgets are set

      content = Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
        child: ListView(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: imagesSectionWidget,
            ),
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
                child: textSectionWidget,
              ),
            ),
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
      );
    } else {
      // Show restaurant not found if at least one widget is not set
      content = KeyedSubtree(
        key: const ValueKey("restaurant_overview_not_found"),
        child: ErrorScreenWithAction(
          baseMessageWidget: noRestaurantFound,
          buttonLabel: 'Reload restaurant',
          buttonAction: _loadRestaurantOverview,
          errorMessage: state.errorMessage,
        ),
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: content,
        // child: Text('hello'),
      ),
    );
  }
}
