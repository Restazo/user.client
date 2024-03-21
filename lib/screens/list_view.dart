import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:restazo_user_mobile/providers/restaurants_near_you.dart';
import 'package:restazo_user_mobile/widgets/loaders/restaurants_near_you_loader.dart';
import 'package:restazo_user_mobile/widgets/restaurant_near_you_item.dart';

class RestaurantsListViewScreen extends ConsumerStatefulWidget {
  const RestaurantsListViewScreen({super.key});

  @override
  ConsumerState<RestaurantsListViewScreen> createState() =>
      _RestaurantsListViewScreenState();
}

class _RestaurantsListViewScreenState
    extends ConsumerState<RestaurantsListViewScreen> {
  late Future<void> _restaurantsFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _restaurantsFuture =
        ref.read(restaurantsNearYouProvider.notifier).loadRestaurantsNearYou();
    _restaurantsFuture.then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurantsNearYou = ref.watch(restaurantsNearYouProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 20, right: 20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isLoading && restaurantsNearYou.isEmpty
            ? const KeyedSubtree(
                key: ValueKey('loader'),
                child: RestaurantsNearYouLoader(),
              )
            : KeyedSubtree(
                key: const ValueKey('data'),
                child: ListView.builder(
                  itemCount: restaurantsNearYou.length,
                  itemBuilder: (ctx, index) {
                    final item = restaurantsNearYou[index];
                    return RestaurantNearYouCard(
                      restauranInfo: item,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
