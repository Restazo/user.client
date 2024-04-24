import 'package:go_router/go_router.dart';

import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/screens/menu_item.dart';
import 'package:restazo_user_mobile/screens/location_view.dart';
import 'package:restazo_user_mobile/screens/qr_scanner.dart';
import 'package:restazo_user_mobile/screens/restaurant_overview.dart';
import 'package:restazo_user_mobile/screens/settings.dart';
import 'package:restazo_user_mobile/screens/splash.dart';
import 'package:restazo_user_mobile/screens/table_actions/table_actions.dart';
import 'package:restazo_user_mobile/screens/tabs.dart';
import 'package:restazo_user_mobile/screens/waiter_mode/settings.dart';
import 'package:restazo_user_mobile/screens/waiter_mode/tabs.dart';

enum ScreenNames {
  init,
  home,
  restaurantDetail,
  menuItemDetail,
  settings,
  qrScanner,
  waiterHome,
  waiterSettings,
  tableActions,
}

class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/init',
        name: ScreenNames.init.name,
        builder: (context, state) => const LocationView(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const RestazoSplashScreen(),
      ),
      GoRoute(
        path: '/',
        name: ScreenNames.home.name,
        builder: (context, state) => const TabsScreen(),
        routes: [
          GoRoute(
            path: '$restaurantsEndpoint/:$restaurantIdParamName',
            name: ScreenNames.restaurantDetail.name,
            builder: (context, state) => const RestaurantOverviewScreen(),
            routes: [
              GoRoute(
                path: '$menuEndpoint/:$itemIdParamName',
                name: ScreenNames.menuItemDetail.name,
                builder: (context, state) {
                  final Map<String, bool>? extra =
                      state.extra as Map<String, bool>?;

                  bool fromRestaurantOverview = false;
                  if (extra != null &&
                      extra['fromRestaurantOverview'] != null) {
                    fromRestaurantOverview = true;
                  }

                  return MenuItemScreen(
                      fromRestaurantOverview: fromRestaurantOverview);
                },
              )
            ],
          ),
          GoRoute(
            path: 'settings',
            name: ScreenNames.settings.name,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'qr_scanner',
            name: ScreenNames.qrScanner.name,
            builder: (context, state) => const QrScannerScreen(),
          ),
          GoRoute(
            path: 'table/:$tableHashParamName',
            name: ScreenNames.tableActions.name,
            builder: (context, state) => const TableActionsScreen(),
          ),
          GoRoute(
            path: waiterEndpoint,
            name: ScreenNames.waiterHome.name,
            builder: (context, state) {
              final Map<String, bool>? extra =
                  state.extra as Map<String, bool>?;

              bool fromConfirmed = false;
              if (extra != null && extra['fromConfirmed'] != null) {
                fromConfirmed = true;
              }

              return WaiterModeTabsScreen(fromConfirmed: fromConfirmed);
            },
            routes: [
              GoRoute(
                path: 'settings',
                name: ScreenNames.waiterSettings.name,
                builder: (context, state) => const WaiterModeSettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
