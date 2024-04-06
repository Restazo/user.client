import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:restazo_user_mobile/dummy/not_existing_screen.dart';

import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/screens/restaurant_overview.dart';
import 'package:restazo_user_mobile/screens/tabs.dart';

enum ScreenNames {
  init,
  home,
  restaurantDetail,
  menuItemDetail,
  settings,
  qrScanner,
}

class AppRouter {
  AppRouter({required this.initialLocation});

  final String initialLocation;

  late final GoRouter router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/init',
        name: ScreenNames.init.name,
        builder: (context, state) => const InitScreen(),
      ),
      GoRoute(
        path: '/',
        name: ScreenNames.home.name,
        builder: (context, state) => const TabsScreen(),
        routes: [
          GoRoute(
            path: 'restaurants/:restaurant_id',
            name: ScreenNames.restaurantDetail.name,
            builder: (context, state) => RestaurantOverviewScreen(),
            routes: [
              GoRoute(
                path: 'menu-item/:item_id',
                name: ScreenNames.menuItemDetail.name,
                builder: (context, state) => const NotExistingScreen(),
              )
            ],
          ),
          GoRoute(
            path: 'settings',
            name: ScreenNames.settings.name,
            builder: (context, state) => const NotExistingScreen(),
          ),
          GoRoute(
            path: 'qr_scanner',
            name: ScreenNames.qrScanner.name,
            builder: (context, state) => const NotExistingScreen(),
          )
        ],
      ),
    ],
  );
}

// TODO: Delete this screen
class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final storage = const FlutterSecureStorage();

  Future _continue() async {
    String deviceId = "your_generated_device_id";
    await storage.write(key: "deviceId", value: deviceId);
    if (mounted) {
      context.goNamed("restaurants");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("hello"),
        actions: [
          IconButton(
            onPressed: _continue,
            icon: const Icon(Icons.golf_course),
          ),
        ],
      ),
    );
  }
}
