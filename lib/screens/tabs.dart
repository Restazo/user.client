import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:restazo_user_mobile/screens/list_view.dart';
import 'package:restazo_user_mobile/screens/map.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _tabSwitchButtonAnimationController;
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    const RestaurantsListViewScreen(),
    const MapScreen(),
  ];

  @override
  void initState() {
    super.initState();

    _tabSwitchButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
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

  @override
  Widget build(BuildContext context) {
    String activePageTitle = "Near You";

    if (_selectedPageIndex == 1) {
      activePageTitle = 'Map';
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          // Clip the widget to only apply effects within its bounds
          child: BackdropFilter(
            // Apply a filter to the background content
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), // Blur effect
            child: AppBar(
              scrolledUnderElevation: 0.0,
              title: Text(
                activePageTitle,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
              ),
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
              centerTitle: true,
              leading: IconButton(
                highlightColor: Theme.of(context).highlightColor,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                },
                icon: Image.asset(
                  'assets/setting.png',
                  width: 28,
                  height: 28,
                ),
              ),
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
