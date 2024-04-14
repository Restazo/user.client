import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:restazo_user_mobile/providers/restaurants_near_you.dart';
import 'package:restazo_user_mobile/widgets/error_widgets/error_screen.dart';
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

    ref
        .read(restaurantsNearYouProvider.notifier)
        .loadRestaurantsNearYou()
        .then((_) {
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
    Widget noRestaurantsFound = Center(
      child: Text(
        "No restaurants found",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white,
            ),
      ),
    );

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
    } else if (state.errorMessage != null && !_isLoading) {
      // Show the error message if error is present in the state
      content = KeyedSubtree(
        key: const ValueKey('restaurants_not_found_message'),
        child: ErrorScreenWithAction(
          baseMessageWidget: noRestaurantsFound,
          errorMessage: state.errorMessage!,
          buttonAction: reloadRestaurants,
          buttonLabel: 'Reload restaurants',
        ),
      );
    } else {
      // List is empty show the message
      content = noRestaurantsFound;
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
