import 'package:go_router/go_router.dart';

import 'package:restazo_user_mobile/screens/location_view.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/screens/restaurant_overview.dart';
import 'package:restazo_user_mobile/screens/tabs.dart';

class AppRouter {
  AppRouter({required this.initialLocation});

  final String initialLocation;

  late final GoRouter router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'init',
        builder: (context, state) => const LocationView(),
      ),
      GoRoute(
        path: '/restaurants',
        name: 'restaurants',
        builder: (context, state) => const TabsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'restaurantDetail',
            builder: (context, state) {
              final RestaurantNearYou restaurantInitData =
                  state.extra as RestaurantNearYou;

              return RestaurantOverviewScreen(
                  restaurantInitData: restaurantInitData);
            },
          ),
        ],
      )
    ],
  );
}
