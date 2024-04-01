import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:restazo_user_mobile/dummy/menu.dart';
import 'package:restazo_user_mobile/models/menu_category.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/widgets/menu_section.dart';
import 'package:restazo_user_mobile/widgets/restaurant_overview_images.dart';
import 'package:restazo_user_mobile/widgets/restaurant_text_info.dart';

class RestaurantOverviewScreen extends StatefulWidget {
  const RestaurantOverviewScreen({super.key, required this.restaurantInitData});

  final RestaurantNearYou restaurantInitData;

  @override
  State<RestaurantOverviewScreen> createState() =>
      _RestaurantOverviewScreenState();
}

class _RestaurantOverviewScreenState extends State<RestaurantOverviewScreen>
    with TickerProviderStateMixin {
  late List<MenuCategory> menuItems;

  @override
  void initState() {
    super.initState();
    // TODO: load the data from the API
    // final restaurantFullData = await ApiService().loadRestaurant(widget.restaurantInitData.id)

    setState(() {
      menuItems = menu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: AppBar(
              scrolledUnderElevation: 0.0,
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
              leading: IconButton(
                splashColor: Theme.of(context).splashColor,
                highlightColor: Theme.of(context).highlightColor,
                // iconSize: 28,
                icon: Image.asset(
                  'assets/left.png',
                  width: 28,
                  height: 28,
                ),
                onPressed: () {
                  context.pop();
                },
              ),
              actions: [
                IconButton(
                  splashColor: Theme.of(context).splashColor,
                  highlightColor: Theme.of(context).highlightColor,
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/qr-code-scan.png',
                    width: 28,
                    height: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
        child: ListView(
          children: [
            RestaurantOverviewImages(
              coverImage: widget.restaurantInitData.coverImage,
              logoImage:
                  'https://images.unsplash.com/photo-1568376794508-ae52c6ab3929?q=80&w=2000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ),
            RestaurantOverviewTextInfo(
                restaurantInfo: widget.restaurantInitData),
            RestaurantOverviewMenuSection(menu: menuItems)
          ],
        ),
      ),
    );
  }
}
