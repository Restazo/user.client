import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restazo_user_mobile/screens/list_view.dart';
import 'package:restazo_user_mobile/screens/map.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectScreen(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = const RestaurantsListViewScreen();
    String activePageTitle = "Near You";

    if (_selectedPageIndex == 1) {
      activeScreen = const MapScreen();
      activePageTitle = 'Map';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          activePageTitle,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      body: activeScreen,
      bottomNavigationBar: Container(
        // padding: const EdgeInsets.only(top: 14.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(61, 15, 34, 40),
              Color.fromARGB(255, 22, 32, 35),
            ],
          ),
        ),
        child: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          onTap: _selectScreen,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/serving-dish.png",
                width: 28,
                height: 28,
                color: _selectedPageIndex == 0
                    ? Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor
                    : Theme.of(context)
                        .bottomNavigationBarTheme
                        .unselectedItemColor,
              ),
              label: "Restaurants",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/map.png",
                width: 28,
                height: 28,
                color: _selectedPageIndex == 1
                    ? Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor
                    : Theme.of(context)
                        .bottomNavigationBarTheme
                        .unselectedItemColor,
              ),
              label: "Map",
            )
          ],
        ),
      ),
    );
  }
}
