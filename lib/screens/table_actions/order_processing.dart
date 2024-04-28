import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/models/order_menu_item.dart';
import 'package:restazo_user_mobile/providers/place_order_button_provider.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/buttom_sheet_with_menu_items.dart';
import 'package:restazo_user_mobile/widgets/error_widgets/error_screen.dart';

class OrderProcessingScreen extends ConsumerStatefulWidget {
  const OrderProcessingScreen({super.key});

  @override
  ConsumerState<OrderProcessingScreen> createState() =>
      _OrderProcessingScreenState();
}

class _OrderProcessingScreenState extends ConsumerState<OrderProcessingScreen> {
  WebSocketChannel? channel;
  bool _isLoading = false;
  final storage = const FlutterSecureStorage();
  bool screenInitialised = false;
  Future<void>? connectingFuture;
  List<OrderProcessingMenuItem>? orderItems;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!screenInitialised) {
      connectingFuture = connectWebSocket();
      screenInitialised = true;
    }
  }

  @override
  void dispose() {
    channel?.sink.close();
    connectingFuture?.ignore();
    super.dispose();
  }

  String? getOrderIdFromParameters() {
    final Map<String, String> parametersMap =
        GoRouterState.of(context).pathParameters;

    if (parametersMap[orderIdKeyname] == null) {
      showCupertinoDialogWithOneAction(
          context, "Error", "No order ID provided", Strings.ok, () {
        context.goNamed(ScreenNames.tableActions.name);
      });
      return null;
    }
    return parametersMap[orderIdKeyname];
  }

  Future<void> connectWebSocket() async {
    setState(() {
      _isLoading = true;
    });
    final orderId = getOrderIdFromParameters();

    final [deviceId, tableSessionAccessToken] = await Future.wait([
      storage.read(key: deviceIdKeyName),
      storage.read(key: tableSessionAccessTokenKeyName),
    ]);

    try {
      channel = IOWebSocketChannel.connect(
        wsServerUrl,
        headers: {
          'Authorization': 'Bearer $tableSessionAccessToken',
          'deviceid': '$deviceId',
        },
      );

      await channel!.ready;

      final message = {
        "path": "/subscribe/order",
        "payload": {
          "accessToken": 'Bearer $tableSessionAccessToken',
          "orderId": orderId
        }
      };

      channel!.sink.add(json.encode(message));

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void goHome() {
    context.goNamed(ScreenNames.tableActions.name);
  }

  Widget buildLoadingUI() {
    return KeyedSubtree(
      key: const ValueKey("order_subscribing_loader"),
      child: Center(
          child: LoadingAnimationWidget.dotsTriangle(
              color: Colors.white, size: 48)),
    );
  }

  Widget buildOrderStatusUI(String topMessage, void Function() buttonAction,
      String buttonLabel, Widget middleWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          flex: 152,
          child: SizedBox(),
        ),
        Expanded(
          flex: 320,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  topMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 0,
                      ),
                ),
              ),
              middleWidget,
              TextButton(
                onPressed: buttonAction,
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return const Color.fromARGB(255, 200, 200, 200);
                      }
                      return null;
                    },
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          flex: 252,
          child: SizedBox(),
        ),
      ],
    );
  }

  Widget buildContentUI() {
    return KeyedSubtree(
      key: const ValueKey("order_processing_screen_data"),
      child: StreamBuilder(
        stream: channel!.stream,
        builder: (context, snapshot) {
          Widget content = buildLoadingUI();

          if (snapshot.connectionState == ConnectionState.done) {
            content = KeyedSubtree(
                key: const ValueKey("connection_closed_ui_on_order_processing"),
                child: ErrorScreenWithAction(
                  baseMessageWidget: Text(
                    'Connection closed',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                  ),
                  errorMessage: "Server closed the connection",
                ));
          }

          if (snapshot.hasData) {
            final message = json.decode(snapshot.data);

            if (message['status'] != null) {
              final String status = message['status'];

              if (status == 'success') {
                if (message['data'] != null) {
                  if (message['data']['orderStatus'] == 'pending') {
                    final incomingOrderItems =
                        message['data']['orderItems'] as List<dynamic>;

                    orderItems = incomingOrderItems
                        .map((e) => OrderProcessingMenuItem.fromJson(e))
                        .toList();

                    content = KeyedSubtree(
                      key: const ValueKey(
                          "pending_order_ui_on_order_processing"),
                      child: buildOrderStatusUI(
                        "Your order is being processed at the moment",
                        () {
                          showModalBottomSheetWithMenuItems(
                            context,
                            "Your order items",
                            orderItems,
                            "Cancel",
                            () {
                              context.pop();
                            },
                            null,
                            null,
                          );
                        },
                        "Review your order",
                        LoadingAnimationWidget.inkDrop(
                            color: Colors.white, size: 100),
                      ),
                    );
                  } else if (message['data']['orderStatus'] == 'accepted') {
                    Future.microtask(() {
                      if (mounted) {
                        storage.delete(key: orderIdKeyname);
                        ref
                            .read(placeOrderButtonProvider.notifier)
                            .updateButtonLabel("Place an order");
                      }
                    });

                    content = KeyedSubtree(
                      key: const ValueKey("order_has_been_accepted_ui"),
                      child: buildOrderStatusUI(
                        "Your order has been accepted",
                        () {
                          context.goNamed(ScreenNames.tableActions.name);
                        },
                        "Go to table actions",
                        Image.asset(
                          "assets/tick.png",
                          height: 100,
                          width: 100,
                        ),
                      ),
                    );
                  } else if (message['data']['orderStatus'] == 'declined') {
                    Future.microtask(() {
                      if (mounted) {
                        storage.delete(key: orderIdKeyname);
                        ref
                            .read(placeOrderButtonProvider.notifier)
                            .updateButtonLabel("Place an order");
                      }
                    });

                    content = KeyedSubtree(
                      key: const ValueKey(
                          "order_declined_ui_on_order_processing"),
                      child: buildOrderStatusUI(
                        "Your order has been declined",
                        () {
                          context.goNamed(ScreenNames.tableActions.name);
                        },
                        "Go to table actions",
                        Image.asset(
                          "assets/close.png",
                          height: 100,
                          width: 100,
                        ),
                      ),
                    );
                  }
                }
              } else if (status == 'fail') {
                content = KeyedSubtree(
                    key: const ValueKey(
                        "fail_from_the_server_on_order_processing"),
                    child: ErrorScreenWithAction(
                      baseMessageWidget: Text(
                        "Fail",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                      errorMessage: message['message'],
                    ));
              } else if (status == 'error') {
                content = KeyedSubtree(
                  key: const ValueKey(
                      "error_from_the_server_on_order_processing"),
                  child: ErrorScreenWithAction(
                    baseMessageWidget: Text(
                      "Error",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                    ),
                    errorMessage: message['message'],
                  ),
                );
              }
            } else {
              content = KeyedSubtree(
                key: const ValueKey(
                    "bad_message_from_the_server_on_order_processing"),
                child: ErrorScreenWithAction(
                    baseMessageWidget: Text(
                  "Bad message from the server",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                )),
              );
            }
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: content,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RestazoAppBar(
        leftNavigationIconAsset: 'assets/left.png',
        leftNavigationIconAction: () {
          navigateBack(context);
        },
        title: "Order processing",
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
            child: !_isLoading ? buildContentUI() : buildLoadingUI(),
          ),
        ),
      ),
    );
  }
}
