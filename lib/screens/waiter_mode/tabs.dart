import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/ongoing_orders_at_table.dart';
import 'package:restazo_user_mobile/models/waiter_request.dart';
import 'package:restazo_user_mobile/providers/waiter_ongoing_order_provider.dart';
import 'package:restazo_user_mobile/providers/waiter_requests_provider.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/screens/waiter_mode/ongoing_orders.dart';
import 'package:restazo_user_mobile/screens/waiter_mode/requests.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/bottom_navigation_bar.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WaiterModeTabsScreen extends ConsumerStatefulWidget {
  const WaiterModeTabsScreen({super.key, required this.fromConfirmed});

  final bool fromConfirmed;

  @override
  ConsumerState<WaiterModeTabsScreen> createState() =>
      _WaiterModeTabsScreenState();
}

class _WaiterModeTabsScreenState extends ConsumerState<WaiterModeTabsScreen> {
  WebSocketChannel? channel;
  final storage = const FlutterSecureStorage();
  bool screenInitialised = false;
  Future<void>? initFuture;
  bool _isLoading = false;
  int _selectedPageIndex = 0;
  List<Widget> get _pages {
    return [
      const PendingRequestsScreen(),
      const OngoingOrdersScreen(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!screenInitialised) {
      initFuture = initWaiterTabsScreen();
    }
  }

  @override
  void dispose() {
    initFuture?.ignore();
    channel?.sink.close();
    super.dispose();
  }

  Future<void> _checkWaiterSession() async {
    final accessToken = await storage.read(key: accessTokenKeyName);

    if (accessToken == null) {
      if (mounted) {
        await showCupertinoDialogWithOneAction(
          context,
          "Invalid session",
          "Seems like you are logged out, please log in again",
          Strings.ok,
          _goHome,
        );
      }
      return;
    }

    final result = await APIService().getWaiterSession(accessToken);

    if (!result.isSuccess) {
      await storage.delete(key: accessTokenKeyName);

      if (mounted) {
        await showCupertinoDialogWithOneAction(
          context,
          "Error",
          result.errorMessage!,
          Strings.ok,
          _goHome,
        );
      }
      return;
    }

    if (result.sessionMessage != null) {
      await storage.delete(key: accessTokenKeyName);

      if (mounted) {
        showCupertinoDialogWithOneAction(
          context,
          Strings.failTitle,
          result.sessionMessage!,
          Strings.ok,
          _goHome,
        );
      }
      return;
    }

    await Future.wait([
      // storage.write(key: accessTokenKeyName, value: result.data!.accessToken),
      storage.write(key: waiterNameKeyName, value: result.data!.name),
      storage.write(key: waiterEmailKeyName, value: result.data!.email),
    ]);
  }

  Future<void> initWaiterTabsScreen() async {
    setState(() {
      _isLoading = true;
    });
    if (!widget.fromConfirmed) {
      await _checkWaiterSession();
    }
    await connectToRestaurant();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> connectToRestaurant() async {
    final [deviceId, waiterAccessToken] = await Future.wait([
      storage.read(key: deviceIdKeyName),
      storage.read(key: accessTokenKeyName),
    ]);

    try {
      channel = IOWebSocketChannel.connect(
        wsServerUrl,
        headers: {
          'Authorization': 'Bearer $waiterAccessToken',
          'deviceid': '$deviceId',
        },
      );

      await channel!.ready;

      final message = {
        "path": "/subscribe/restaurant",
        "payload": {
          "accessToken": 'Bearer $waiterAccessToken',
        }
      };

      channel!.sink.add(json.encode(message));

      channel!.stream.listen(
        (event) {
          try {
            final snapshot = json.decode(event);
            if (snapshot['field'] != null) {
              final field = snapshot['field'];
              if (field == 'ongoingOrders') {
                final tables = snapshot['tables'] as List<dynamic>;

                final List<OngoingOrder> ongoingOrders =
                    tables.map((e) => OngoingOrder.fromJson(e)).toList();

                Future.microtask(() {
                  if (mounted) {
                    ref
                        .read(ongoingOrdersProvider.notifier)
                        .setNewOngoingOrders(ongoingOrders);
                  }
                });
              } else if (field == 'requests') {
                final requests = Requests.fromJson(snapshot['data']);
                Future.microtask(() {
                  if (mounted) {
                    ref
                        .read(waiterRequestsProvider.notifier)
                        .setNewRequests(requests);
                  }
                });
              }
            }
          } catch (e) {
            showCupertinoDialogWithOneAction(context, "Error",
                "Received invalid message from the server", Strings.ok, () {
              navigateBack(context);
            });
          }
        },
        onDone: () {
          showCupertinoDialogWithOneAction(
            context,
            "Closed connection",
            "Server closed connection to the restaurant",
            Strings.ok,
            () {
              navigateBack(context);
            },
          );
        },
      );
    } catch (e) {
      if (mounted) {
        showCupertinoDialogWithOneAction(
          context,
          "Error",
          "Something went wrong",
          Strings.ok,
          () {
            navigateBack(context);
          },
        );
      }
    }
  }

  void _goHome() {
    context.goNamed(ScreenNames.home.name);
  }

  void _openSettingsScreen() {
    context.goNamed(ScreenNames.waiterSettings.name);
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String activePageTitle = "Requests";

    if (_selectedPageIndex == 1) {
      activePageTitle = 'Ongoing orders';
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: RestazoAppBar(
        title: activePageTitle,
        leftNavigationIconAction: _openSettingsScreen,
        leftNavigationIconAsset: 'assets/setting.png',
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: !_isLoading && channel != null
            ? KeyedSubtree(
                key: const ValueKey("waiter_mode_tabs_ui"),
                child: IndexedStack(
                  index: _selectedPageIndex,
                  children: _pages,
                ),
              )
            : KeyedSubtree(
                key: const ValueKey("waiter_mode_loader_ui"),
                child: Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                      color: Colors.white, size: 48),
                ),
              ),
      ),
      bottomNavigationBar: RestazoBottomNavigationBar(
        leftItemAsset: "assets/message.png",
        leftItemLabel: "Requests",
        rightItemAsset: "assets/menu.png",
        rightItemLabel: "Ongoing orders",
        selectScreen: _selectScreen,
      ),
    );
  }
}
