import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantsListViewScreen extends ConsumerStatefulWidget {
  const RestaurantsListViewScreen({super.key});

  @override
  ConsumerState<RestaurantsListViewScreen> createState() =>
      _RestaurantsListViewScreenState();
}

class _RestaurantsListViewScreenState
    extends ConsumerState<RestaurantsListViewScreen> {
  @override
  void initState() {
    super.initState();
    // Load the data
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Restaurants list view"),
    );
  }
}
