import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OrderProcessingScreen extends StatefulWidget {
  const OrderProcessingScreen({super.key});

  @override
  State<OrderProcessingScreen> createState() => _OrderProcessingScreenState();
}

class _OrderProcessingScreenState extends State<OrderProcessingScreen> {
  WebSocketChannel? channel;
  bool _isLoading = false;
  final storage = const FlutterSecureStorage();
  bool screenInitialised = false;
  Future<void>? connectingFuture;

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
    print('disconnected');

    channel?.sink.close();
    connectingFuture?.ignore();
    super.dispose();
  }

  Future<void> connectWebSocket() async {
    setState(() {
      _isLoading = true;
    });

    final [deviceId, tableSessionAccessToken] = await Future.wait([
      storage.read(key: deviceIdKeyName),
      storage.read(key: tableSessionAccessTokenKeyName),
    ]);

    try {
      channel = IOWebSocketChannel.connect(
        'wss://ws.restazo.com',
        headers: {
          'Authorization': 'Bearer $tableSessionAccessToken',
          'deviceid': '$deviceId',
        },
      );

      await channel!.ready;
      print('connected');

      setState(() {
        _isLoading = true;
      });
    } catch (e) {
      print('WebSocket connection failed: $e');
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = KeyedSubtree(
      key: const ValueKey("order_subscribing_loader"),
      child: Center(
          child: LoadingAnimationWidget.dotsTriangle(
              color: Colors.white, size: 48)),
    );

    if (channel != null) {
      content = KeyedSubtree(
        key: const ValueKey("order_processing_screen_data"),
        child: StreamBuilder(
          stream: channel!.stream,
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(flex: 152),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "message",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                    LoadingAnimationWidget.beat(color: Colors.white, size: 64),
                  ],
                ),
                const Expanded(flex: 252),
              ],
            );
          },
        ),
      );
    }

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
            child: content,
          ),
        ),
      ),
    );
  }
}
