import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';

import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/providers/restaurants_near_you.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/screens/list_view.dart';
import 'package:restazo_user_mobile/screens/map.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _tabSwitchButtonAnimationController;
  int _selectedPageIndex = 0;

  List<Widget> get _pages {
    return [
      RestaurantsListViewScreen(reloadRestaurants: reloadRestaurants),
      const MapScreen(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _ensureDeviceIdPresent();

    _tabSwitchButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  Future<void> reloadRestaurants(LocationData? currentLocation) async {
    await ref
        .read(restaurantsNearYouProvider.notifier)
        .loadRestaurantsNearYou(currentLocation);
  }

  @override
  void dispose() {
    // Stop and dispose all the animation controllers
    _tabSwitchButtonAnimationController.stop();
    _tabSwitchButtonAnimationController.dispose();
    super.dispose();
  }

  // Create animated bottom navigation item
  BottomNavigationBarItem createBottomNavItem({
    required String iconPath,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedBuilder(
        animation: _tabSwitchButtonAnimationController,
        builder: (context, _) {
          final double yOffset = isSelected
              ? Tween<double>(begin: 0.0, end: -7.0)
                      .animate(
                        CurvedAnimation(
                          parent: _tabSwitchButtonAnimationController,
                          curve: Curves.easeOut,
                        ),
                      )
                      .value *
                  (1 - _tabSwitchButtonAnimationController.value) *
                  2
              : 0.0;

          return Transform.translate(
            offset: Offset(0, yOffset),
            child: Image.asset(
              iconPath,
              width: 28,
              height: 28,
              color: isSelected
                  ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
            ),
          );
        },
      ),
      label: label,
    );
  }

  Future<void> _ensureDeviceIdPresent() async {
    const storage = FlutterSecureStorage();
    final deviceId = await storage.read(key: 'deviceId');

    if (deviceId == null) {
      final deviceIdState = await APIService().getDeviceId();
      if (deviceIdState.data != null) {
        await storage.write(
          key: 'deviceId',
          value: deviceIdState.data!.deviceId,
        );
      }
    }
  }

  void _selectScreen(int index) {
    // Run the tab item animation only if it is not active
    if (_selectedPageIndex != index) {
      _tabSwitchButtonAnimationController.forward(from: 0.0);
    }

    setState(() {
      _selectedPageIndex = index;
    });

    // Give some light haptic feedback
    HapticFeedback.lightImpact();
  }

  void _openSettingsScreen() {
    context.goNamed(ScreenNames.settings.name);
  }

  void _openQrScanner() {
      openQrScanner(context);
  }

  @override
  Widget build(BuildContext context) {
    String activePageTitle = "Near You";

    if (_selectedPageIndex == 1) {
      activePageTitle = 'Map';
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultAppBar(
        title: activePageTitle,
        leftNavigationIconAsset: 'assets/setting.png',
        leftNavigationIconAction: _openSettingsScreen,
        rightNavigationIconAsset: 'assets/qr-code-scan.png',
        rightNavigationIconAction: _openQrScanner,
      ),
      body: IndexedStack(
        index: _selectedPageIndex,
        children: _pages,
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(62, 15, 34, 40),
              Color.fromARGB(200, 14, 35, 42),
              Color.fromARGB(245, 16, 30, 35),
              Color.fromARGB(255, 19, 31, 35),
              Color.fromARGB(255, 22, 32, 35),
            ],
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            // Override the canvas color to transparent to let the gradient show through
            canvasColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            onTap: _selectScreen,
            currentIndex: _selectedPageIndex,
            items: [
              createBottomNavItem(
                iconPath: "assets/serving-dish.png",
                label: "Restaurants",
                isSelected: _selectedPageIndex == 0,
              ),
              createBottomNavItem(
                iconPath: "assets/map.png",
                label: "Map",
                isSelected: _selectedPageIndex == 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
