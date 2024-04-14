import 'package:go_router/go_router.dart';

import 'package:restazo_user_mobile/dummy/not_existing_screen.dart';
import 'package:restazo_user_mobile/screens/menu_item.dart';
import 'package:restazo_user_mobile/screens/location_view.dart';
import 'package:restazo_user_mobile/screens/restaurant_overview.dart';
import 'package:restazo_user_mobile/screens/settings.dart';
import 'package:restazo_user_mobile/screens/tabs.dart';

enum ScreenNames {
  init,
  home,
  restaurantDetail,
  menuItemDetail,
  settings,
  qrScanner,
  waiterModeLogin
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
        builder: (context, state) => const LocationView(),
      ),
      GoRoute(
        path: '/',
        name: ScreenNames.home.name,
        builder: (context, state) => const TabsScreen(),
        routes: [
          GoRoute(
            path: 'restaurants/:restaurant_id',
            name: ScreenNames.restaurantDetail.name,
            builder: (context, state) => const RestaurantOverviewScreen(),
            routes: [
              GoRoute(
                path: 'menu/:item_id',
                name: ScreenNames.menuItemDetail.name,
                builder: (context, state) => const MenuItemScreen(),
              )
            ],
          ),
          GoRoute(
              path: 'settings',
              name: ScreenNames.settings.name,
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'waiter_mode_login',
                  name: ScreenNames.waiterModeLogin.name,
                  builder: (context, state) => const NotExistingScreen(),
                )
              ]),
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
