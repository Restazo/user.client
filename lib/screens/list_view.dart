import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import 'package:restazo_user_mobile/providers/restaurants_near_you.dart';
import 'package:restazo_user_mobile/widgets/loaders/restaurants_near_you_loader.dart';
import 'package:restazo_user_mobile/widgets/restaurant_near_you_item.dart';
import 'package:restazo_user_mobile/widgets/snack_bar.dart';

class RestaurantsListViewScreen extends ConsumerStatefulWidget {
  const RestaurantsListViewScreen({
    super.key,
    required this.getCurrentLocation,
    required this.reloadRestaurants,
  });

  final Future<LocationData?> Function() getCurrentLocation;
  final Future<void> Function(LocationData?) reloadRestaurants;

  @override
  ConsumerState<RestaurantsListViewScreen> createState() =>
      _RestaurantsListViewScreenState();
}

class _RestaurantsListViewScreenState
    extends ConsumerState<RestaurantsListViewScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    reloadRestaurants();
  }

  void reloadRestaurants() async {
    setState(() {
      _isLoading = true;
    });

    final currentLocation = await widget.getCurrentLocation();

    widget.reloadRestaurants(currentLocation).then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantsNearYouProvider);

    Widget content;

    if (_isLoading) {
      content = const KeyedSubtree(
        key: ValueKey('restaurants_list_view_loader'),
        child: RestaurantsNearYouLoader(),
      );
    } else if (state.data != null && state.data!.isNotEmpty) {
      // List is not null and not empty, show the list
      content = KeyedSubtree(
        key: const ValueKey('data'),
        child: ListView.builder(
          itemCount: state.data!.length,
          itemBuilder: (ctx, index) {
            final item = state.data![index];
            return RestaurantNearYouCard(
              restauranInfo: item,
            );
          },
        ),
      );
    } else {
      // List is empty or an error occurred, show the message
      content = KeyedSubtree(
        key: const ValueKey('message'),
        child: Center(
          child: Text(
            "No restaurants found",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      );
    }

    // Show snackbar on error
    if (state.errorMessage != null && !_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ScaffoldMessenger.of(context)
              .clearSnackBars(); // Clear existing snackbars first
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarWithAction.create(
              content: Text(
                state.errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
              actionFunction: reloadRestaurants,
              actionLabel: "Reload",
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 20, right: 20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: content,
      ),
    );
  }
}
