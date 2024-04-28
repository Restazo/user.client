import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:restazo_user_mobile/providers/menu_item_bottom_button_provider.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/currency.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/providers/menu_item_provider.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/error_widgets/error_screen.dart';
import 'package:restazo_user_mobile/widgets/loaders/menu_item_loader.dart';

class MenuItemScreen extends ConsumerStatefulWidget {
  const MenuItemScreen({super.key, required this.fromRestaurantOverview});

  final bool fromRestaurantOverview;

  @override
  ConsumerState<MenuItemScreen> createState() => _MenuItemScreenState();
}

class _MenuItemScreenState extends ConsumerState<MenuItemScreen> {
  bool _isLoading = false;
  bool _screenInitialised = false;
  Future<void>? _loadMenuItemDataFuture;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _updateNavigationIconAndAction();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_screenInitialised) {
      if (!widget.fromRestaurantOverview) {
        _loadMenuItemDataFuture = _loadMenuItemData();
      }
      _screenInitialised = true;
    }
  }

  @override
  void dispose() {
    if (_loadMenuItemDataFuture != null) {
      _loadMenuItemDataFuture!.ignore();
    }

    super.dispose();
  }

  Future<void> _loadMenuItemData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    final menuItemDataState = ref.watch(menuItemProvider);

    final Map<String, String> existingParametersMap =
        GoRouterState.of(context).pathParameters;

    final restaurantId = existingParametersMap[restaurantIdParamName]!;
    final itemId = existingParametersMap[itemIdParamName]!;

    if (menuItemDataState.initailMenuItemData == null) {
      await ref
          .read(menuItemProvider.notifier)
          .loadMenuItemData(itemId, restaurantId);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMenuItemUi({
    required String? coverImage,
    required String name,
    required double price,
    required String currency,
    required String? description,
    required String ingredients,
  }) {
    final state = ref.watch(menuItemButtonProvider);

    Widget coverWidget = coverImage != null
        ? CachedNetworkImage(
            imageUrl: coverImage,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(50, 255, 255, 255),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 60, 60, 60)),
              child: const Icon(
                Icons.error,
                color: Colors.white,
              ),
            ),
          )
        : Container(
            height: 128,
            width: 128,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(50, 255, 255, 255)),
            child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 60, 60, 60)),
              child: const Icon(
                Icons.food_bank_rounded,
                color: Colors.white,
              ),
            ),
          );

    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: 36,
      ),
      child: Stack(
        children: [
          ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 8,
                      blurRadius: 10,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 350 / 214,
                    child: coverWidget,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      spreadRadius: 6,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                name,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: 20,
                                        height: 1,
                                        overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ),
                          Text(
                            '$price${CurrencyHelper.getSymbol(currency)}',
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                    height: 1,
                                    overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      SizedBox(height: description != null ? 16 : 0),
                      Text(
                        description ?? '',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontSize: description != null ? 12 : 0,
                            ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      spreadRadius: 6,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingredients',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                  height: 1,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ingredients,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                            ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color.fromARGB(255, 200, 200, 200);
                    }
                    return null;
                  },
                ),
              ),
              onPressed: state.buttonLabel == "Scan table QR"
                  ? _openQrScanner
                  : openTableActions,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  state.buttonLabel,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _navigateBack() {
    ref.read(menuItemProvider.notifier).leaveMenuItemScreen();
    navigateBack(context);
  }

  void _openQrScanner() {
    openQrScanner(context, mounted);
  }

  void openTableActions() {
    context.goNamed(ScreenNames.tableActions.name);
  }

  void _shareItem() {
    final Map<String, String> parametersMap =
        GoRouterState.of(context).pathParameters;

    Share.share(
        "$userWebAppUrl/$restaurantsEndpoint/${parametersMap[restaurantIdParamName]}/$menuEndpoint/${parametersMap[itemIdParamName]}");
  }

  void _updateNavigationIconAndAction() {
    final tableSessionAccessToken =
        storage.read(key: tableSessionAccessTokenKeyName);

    tableSessionAccessToken.then((token) {
      if (token != null) {
        ref
            .read(menuItemButtonProvider.notifier)
            .updateButtonLabel('Open table session');
      } else {
        ref
            .read(menuItemButtonProvider.notifier)
            .updateButtonLabel("Scan table QR");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(menuItemProvider);
    Widget content;
    bool itemFound = false;

    final Widget noMealFound = Center(
      child: Text(
        "No menu item found",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.white),
      ),
    );

    if (_isLoading) {
      content = const KeyedSubtree(
        key: ValueKey('menu_item_loader'),
        child: MenuItemLoader(),
      );
    } else if (state.initailMenuItemData != null) {
      itemFound = true;

      content = KeyedSubtree(
          key: const ValueKey('menu_item_data'),
          child: _buildMenuItemUi(
            coverImage: state.initailMenuItemData!.imageUrl,
            name: state.initailMenuItemData!.name,
            description: state.initailMenuItemData!.description,
            ingredients: state.initailMenuItemData!.ingredients,
            price: state.initailMenuItemData!.priceAmount,
            currency: state.initailMenuItemData!.priceCurrency,
          ));
    } else if (!_isLoading &&
        state.initailMenuItemData == null &&
        state.data != null) {
      itemFound = true;

      content = KeyedSubtree(
          key: const ValueKey('menu_item_data'),
          child: _buildMenuItemUi(
            coverImage: state.data!.imageUrl,
            name: state.data!.name,
            description: state.data!.description,
            ingredients: state.data!.ingredients,
            price: state.data!.priceAmount,
            currency: state.data!.priceCurrency,
          ));
    } else {
      content = KeyedSubtree(
        key: const ValueKey("restaurant_overview_not_found"),
        child: ErrorScreenWithAction(
          baseMessageWidget: noMealFound,
          buttonLabel: 'Reload menu item',
          buttonAction: _loadMenuItemData,
          errorMessage: state.errorMessage,
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: RestazoAppBar(
        leftNavigationIconAsset: 'assets/left.png',
        leftNavigationIconAction: _navigateBack,
        rightNavigationIconAsset: itemFound ? 'assets/external-link.png' : null,
        rightNavigationIconAction: itemFound ? _shareItem : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: content,
      ),
    );
  }
}
