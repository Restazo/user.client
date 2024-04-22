import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:restazo_user_mobile/env.dart';

import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/screens/list_view.dart';
import 'package:restazo_user_mobile/screens/map.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/bottom_navigation_bar.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  List<Widget> get _pages {
    return [
      const RestaurantsListViewScreen(),
      const MapScreen(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _ensureDeviceIdPresent();
  }

  Future<void> _ensureDeviceIdPresent() async {
    const storage = FlutterSecureStorage();
    final deviceId = await storage.read(key: deviceIdKeyName);

    if (deviceId == null) {
      final deviceIdState = await APIService().getDeviceId();
      if (deviceIdState.data != null) {
        await storage.write(
          key: deviceIdKeyName,
          value: deviceIdState.data!.deviceId,
        );
      }
    }
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
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
      extendBody: true,
      appBar: RestazoAppBar(
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
      bottomNavigationBar: RestazoBottomNavigationBar(
        leftItemAsset: "assets/serving-dish.png",
        leftItemLabel: "Restaurants",
        rightItemAsset: "assets/map.png",
        rightItemLabel: "Map",
        selectScreen: _selectScreen,
      ),
    );
  }
}
