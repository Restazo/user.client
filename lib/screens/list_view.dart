import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import 'package:restazo_user_mobile/providers/restaurants_near_you.dart';
import 'package:restazo_user_mobile/widgets/loaders/restaurants_near_you_loader.dart';
import 'package:restazo_user_mobile/widgets/restaurant_near_you_item.dart';

class RestaurantsListViewScreen extends ConsumerStatefulWidget {
  const RestaurantsListViewScreen(
      {super.key,
      required this.getCurrentLocation,
      required this.reloadRestaurants});

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
        key: ValueKey('loader'),
        child: RestaurantsNearYouLoader(),
      );
    } else if (state.restaurants != null && state.restaurants!.isNotEmpty) {
      // List is not null and not empty, show the list
      content = KeyedSubtree(
        key: const ValueKey('data'),
        child: ListView.builder(
          itemCount: state.restaurants!.length,
          itemBuilder: (ctx, index) {
            final item = state.restaurants![index];
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
    if (state.error != null && !_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .clearSnackBars(); // Clear existing snackbars first
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            state.error!,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
          duration: const Duration(minutes: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
          backgroundColor: const Color.fromARGB(255, 22, 32, 35),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: "Reload",
            onPressed: reloadRestaurants,
            textColor: Colors.green,
          ),
        ));
      });
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
