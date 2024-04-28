import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/providers/tabs_screen_top_right_corner_content_provider.dart';
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
  final storage = const FlutterSecureStorage();
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateNavigationIconAndAction();
    _initTablScreen();
  }

  void _updateNavigationIconAndAction() {
    final tableSessionAccessToken =
        storage.read(key: tableSessionAccessTokenKeyName);
    tableSessionAccessToken.then((token) {
      if (token != null) {
        ref
            .read(topRightCornerContentProvider.notifier)
            .updateTopRightCornerAsset('assets/reception-bell.png');
      } else {
        ref
            .read(topRightCornerContentProvider.notifier)
            .updateTopRightCornerAsset('assets/qr-code-scan.png');
      }
    });
  }

  Future<void> _initTablScreen() async {
    // await storage.delete(key: deviceIdKeyName);
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
    openQrScanner(context, mounted);
  }

  @override
  Widget build(BuildContext context) {
    final topRightCornerAsset = ref.watch(topRightCornerContentProvider).asset;

    VoidCallback? rightCornerAction;
    if (topRightCornerAsset == 'assets/reception-bell.png') {
      rightCornerAction = () => context.goNamed(ScreenNames.tableActions.name);
    } else if (topRightCornerAsset == 'assets/qr-code-scan.png') {
      rightCornerAction = () => _openQrScanner();
    }

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
        rightNavigationIconAsset: topRightCornerAsset,
        rightNavigationIconAction: rightCornerAction,
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
