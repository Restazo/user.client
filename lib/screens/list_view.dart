import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:restazo_user_mobile/providers/restaurants_near_you.dart';
import 'package:restazo_user_mobile/widgets/restaurant_near_you.dart';

class RestaurantsListViewScreen extends ConsumerStatefulWidget {
  const RestaurantsListViewScreen({super.key});

  @override
  ConsumerState<RestaurantsListViewScreen> createState() =>
      _RestaurantsListViewScreenState();
}

class _RestaurantsListViewScreenState
    extends ConsumerState<RestaurantsListViewScreen> {
  late Future<void> _restaurantsFuture;

  @override
  void initState() {
    super.initState();
    _restaurantsFuture =
        ref.read(restaurantsNearYouProvider.notifier).loadRestaurantsNearYou();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantsNearYou = ref.watch(restaurantsNearYouProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 20, right: 20),
      child: FutureBuilder(
        future: _restaurantsFuture,
        builder: (ctx, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: restaurantsNearYou.length,
                  itemBuilder: (ctx, index) {
                    final item = restaurantsNearYou[index];

                    return RestaurantNearYouCard(
                      restauranInfo: item,
                    );
                  },
                );
        },
      ),
    );
  }
}
