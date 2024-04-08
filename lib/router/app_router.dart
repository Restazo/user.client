import 'package:go_router/go_router.dart';
import 'package:restazo_user_mobile/dummy/not_existing_screen.dart';

import 'package:restazo_user_mobile/screens/location_view.dart';
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
