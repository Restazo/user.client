import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:restazo_user_mobile/dummy/menu.dart';
import 'package:restazo_user_mobile/models/menu_category.dart';
import 'package:restazo_user_mobile/widgets/menu_section.dart';
import 'package:restazo_user_mobile/widgets/restaurant_overview_images.dart';
import 'package:restazo_user_mobile/widgets/restaurant_text_info.dart';

class RestaurantOverviewScreen extends StatefulWidget {
  const RestaurantOverviewScreen({super.key});

  // restaurantInfo

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

    // final restaurantData = await ApiService().loadRestaurant(widget.restaurantInfo.id)

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
              actions: [
                IconButton(
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
            const RestaurantOverviewImages(
              coverImage:
                  'https://images.unsplash.com/photo-1571162242324-f1607b1eceaa?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              logoImage:
                  'https://images.unsplash.com/photo-1568376794508-ae52c6ab3929?q=80&w=2000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ),
            const RestaurantOverviewTextInfo(),
            RestaurantOverviewMenuSection(menu: menuItems)
          ],
        ),
      ),
    );
  }
}
