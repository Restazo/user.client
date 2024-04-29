import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restazo_user_mobile/env.dart';

import 'package:restazo_user_mobile/helpers/check_location_permissions.dart';
import 'package:restazo_user_mobile/helpers/get_current_location.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_three_actions.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_two_actions.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/providers/menu_item_bottom_button_provider.dart';
import 'package:restazo_user_mobile/providers/place_order_button_provider.dart';
import 'package:restazo_user_mobile/providers/place_order_provider.dart';
import 'package:restazo_user_mobile/providers/table_session_menu_provider.dart';
import 'package:restazo_user_mobile/providers/tabs_screen_top_right_corner_content_provider.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';

enum CallType {
  waiter,
  bill,
}

class TableActionsScreen extends ConsumerStatefulWidget {
  const TableActionsScreen({super.key, required this.fromQrScan});

  final bool fromQrScan;

  @override
  ConsumerState<TableActionsScreen> createState() => _TableActionsScreenState();
}

class _TableActionsScreenState extends ConsumerState<TableActionsScreen> {
  final storage = const FlutterSecureStorage();
  Future<void>? preparationFunctionFuture;
  bool _screenInitialised = false;
  String? restaurantName;
  String? restaurantLogo;
  bool _isLoading = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (preparationFunctionFuture != null) {
      preparationFunctionFuture!.ignore();
    }

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_screenInitialised) {
      _screenInitialised = true;
      preparationFunctionFuture = _ensureEverythingIsReadyToSendRequests();
    }
  }

  Future<void> _deleteStoredSessionData() async {
    if (ref.read(placeOrderProvider).isNotEmpty) {
      ref.read(placeOrderProvider.notifier).deleteOrderData();
    }

    if (ref.read(tableSessionRestaurantProvider).data != null ||
        ref.read(tableSessionRestaurantProvider).errorMessage != null) {
      ref.read(tableSessionRestaurantProvider.notifier).deleteRestaurantData();
    }

    final List<Future<void>> toDelete = [
      storage.delete(key: tableSessionAccessTokenKeyName),
      storage.delete(key: tableSessionRestaurantIdKeyName),
      storage.delete(key: tableSessionRestaurantNameKeyName),
      storage.delete(key: tableSessionRestaurantLogoKeyname),
    ];

    final String? savedOrderId = await storage.read(key: orderIdKeyname);

    if (savedOrderId != null) {
      toDelete.add(storage.delete(key: orderIdKeyname));
    }

    await Future.wait(toDelete);

    ref
        .read(topRightCornerContentProvider.notifier)
        .updateTopRightCornerAsset('assets/qr-code-scan.png');

    ref
        .read(menuItemButtonProvider.notifier)
        .updateButtonLabel("Scan table QR");

    ref
        .read(placeOrderButtonProvider.notifier)
        .updateButtonLabel("Place an order");
  }

  Future<void> _ensureEverythingIsReadyToSendRequests() async {
    setState(() {
      _isLoading = true;
    });
    // Check all the keys are present

    final result = await Future.wait([
      storage.read(key: tableSessionAccessTokenKeyName),
      storage.read(key: tableSessionRestaurantIdKeyName),
      storage.read(key: tableSessionRestaurantNameKeyName),
    ]);

    if (result.any((element) => element == null)) {
      await _deleteStoredSessionData();
      if (mounted) {
        await showCupertinoDialogWithOneAction(context, "Invalid session",
            "Seems like your table session is invalid", Strings.ok, () {
          context.goNamed(ScreenNames.home.name);
        });
      }
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Check if location permissions are given
    final granted = await checkLocationPermissions();

    if (!granted) {
      if (mounted) {
        await showCupertinoDialogWithOneAction(
            context,
            Strings.lackOfPermissionsTitle,
            Strings.enableLocationMessage,
            Strings.ok, () {
          _goBack();
          _goBack();
        });
      }
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (!widget.fromQrScan) {
      await _checkTableSession(result[0]!);
    }

    ref
        .read(topRightCornerContentProvider.notifier)
        .updateTopRightCornerAsset('assets/reception-bell.png');

    ref
        .read(menuItemButtonProvider.notifier)
        .updateButtonLabel("Open table session");

    final storedOrderId = await storage.read(key: orderIdKeyname);
    if (storedOrderId != null) {
      ref
          .read(placeOrderButtonProvider.notifier)
          .updateButtonLabel("Check my order");
    }

    final [name, logo] = await Future.wait([
      storage.read(key: tableSessionRestaurantNameKeyName),
      storage.read(key: tableSessionRestaurantLogoKeyname)
    ]);

    setState(() {
      restaurantLogo = logo;
      restaurantName = name;
      _isLoading = false;
    });
  }

  Future<void> _checkTableSession(String tableAccessToken) async {
    final sessionResult = await APIService().getTableSession();

    if (!sessionResult.isSuccess) {
      await _deleteStoredSessionData();

      if (mounted) {
        await showCupertinoDialogWithOneAction(
          context,
          "Error",
          sessionResult.errorMessage!,
          Strings.ok,
          () {
            context.goNamed(ScreenNames.home.name);
          },
        );
      }
      return;
    }

    if (sessionResult.sessionMessage != null) {
      await _deleteStoredSessionData();

      if (mounted) {
        showCupertinoDialogWithOneAction(
          context,
          Strings.failTitle,
          sessionResult.sessionMessage!,
          Strings.ok,
          () {
            context.goNamed(ScreenNames.home.name);
          },
        );
      }
      return;
    }

    if (sessionResult.data != null) {
      await Future.wait([
        storage.write(
            key: tableSessionRestaurantIdKeyName,
            value: sessionResult.data!.restaurantId),
        storage.write(
            key: tableSessionRestaurantNameKeyName,
            value: sessionResult.data!.restaurantName),
        storage.write(
            key: tableSessionRestaurantLogoKeyname,
            value: sessionResult.data!.restaurantLogo),
      ]);

      final userLocation = await getCurrentLocation();
      await ref
          .read(tableSessionRestaurantProvider.notifier)
          .loadRestaurantById(sessionResult.data!.restaurantId, userLocation);
    }
  }

  void _goBack() {
    navigateBack(context);
  }

  void showExitDialog() {
    showCupertinoDialogWithThreeActions(
      context,
      Strings.confirmationTitle,
      Strings.confirmToLeaveTableActions,
      "Pause",
      () {
        _goBack();
        _goBack();
      },
      "End",
      () async {
        await _deleteStoredSessionData();

        _goBack();
        _goBack();
      },
      Strings.cancel,
      _goBack,
    );
  }

  void _showRequestTheBill() {
    showCupertinoDialogWithTwoActions(
      context,
      Strings.requestTheBillTitle,
      Strings.confirmationMessageOnRequestBill,
      Strings.cancel,
      _goBack,
      Strings.confirmTitle,
      () {
        callWaiter(CallType.bill);
        _goBack();
      },
    );
  }

  void _showCallWaiter() {
    showCupertinoDialogWithTwoActions(
      context,
      Strings.callWaitertitle,
      Strings.confirmationMessageOnCallWaiter,
      Strings.cancel,
      _goBack,
      Strings.confirmTitle,
      () async {
        callWaiter(CallType.waiter);
        _goBack();
      },
    );
  }

  Future<void> callWaiter(CallType callType) async {
    setState(() {
      _isSubmitting = true;
    });
    final result = await APIService().callWaiter(callType);

    if (result.isSuccess) {
      if (mounted) {
        await showCupertinoDialogWithOneAction(
          context,
          "Success",
          result.data!.message,
          Strings.ok,
          _goBack,
        );
      }
    } else {
      if (mounted) {
        await showCupertinoDialogWithOneAction(
          context,
          "Fail",
          result.errorMessage!,
          Strings.ok,
          _goBack,
        );
      }
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  void _placeAnOrder() {
    context.goNamed(ScreenNames.placeOrder.name);
  }

  Future<void> checkOrder() async {
    final orderId = await storage.read(key: orderIdKeyname);

    if (mounted && orderId != null) {
      context.goNamed(ScreenNames.orderProcessing.name,
          pathParameters: {orderIdKeyname: orderId});
    }
  }

  Widget _buildActionButton(String label, void Function() action) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all<Color>(Colors.black),
          elevation: MaterialStateProperty.all<double>(10),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return const Color.fromARGB(255, 200, 200, 200);
              }
              return null;
            },
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 255, 255, 255)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(24)),
        ),
        onPressed: _isLoading || _isSubmitting ? null : action,
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.black, letterSpacing: 0, fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeAnOrderButtonState = ref.watch(placeOrderButtonProvider);

    Widget validBodyContent = KeyedSubtree(
      key: const ValueKey("table_actions_valid_data_widgets"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  restaurantName != null ? restaurantName! : "No name",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 0,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 128,
                width: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 6,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: restaurantLogo != null
                        ? CachedNetworkImage(
                            imageUrl: restaurantLogo!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(50, 255, 255, 255),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 60, 60, 60)),
                              child: const Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 60, 60, 60)),
                            child: const Icon(
                              Icons.local_dining_outlined,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  _buildActionButton("Request the bill", _showRequestTheBill),
                  const SizedBox(height: 20),
                  _buildActionButton("Call waiter", _showCallWaiter),
                  const SizedBox(height: 20),
                  _buildActionButton(
                      placeAnOrderButtonState.buttonLabel,
                      placeAnOrderButtonState.buttonLabel != "Check my order"
                          ? _placeAnOrder
                          : checkOrder),
                ],
              ),
            ),
          ),
          const SizedBox(),
        ],
      ),
    );

    Widget loadingWidget = KeyedSubtree(
      key: const ValueKey("table_actions_loading_widget"),
      child: Center(
        child:
            LoadingAnimationWidget.dotsTriangle(color: Colors.white, size: 48),
      ),
    );

    return Scaffold(
      appBar: RestazoAppBar(
        title: Strings.tableActionsTitle,
        leftNavigationIconAction: showExitDialog,
        leftNavigationIconAsset: 'assets/left.png',
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 24, bottom: 20, left: 20, right: 20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 29, 39, 42),
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isLoading ? loadingWidget : validBodyContent,
          ),
        ),
      ),
    );
  }
}
