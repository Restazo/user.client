import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/screens/waiter_mode/ongoing_orders.dart';
import 'package:restazo_user_mobile/screens/waiter_mode/requests.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/bottom_navigation_bar.dart';

class WaiterModeTabsScreen extends StatefulWidget {
  const WaiterModeTabsScreen({super.key, required this.fromConfirmed});

  final bool fromConfirmed;

  @override
  State<WaiterModeTabsScreen> createState() => _WaiterModeTabsScreenState();
}

class _WaiterModeTabsScreenState extends State<WaiterModeTabsScreen> {
  int _selectedPageIndex = 0;
  List<Widget> get _pages {
    return [
      const PendingRequestsScreen(),
      const OngoingOrdersScreen(),
    ];
  }

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    if (!widget.fromConfirmed) {
      _checkWaiterSession();
    }
  }

  Future<void> _checkWaiterSession() async {
    final accessToken = await storage.read(key: accessTokenKeyName);

    if (accessToken == null) {
      if (mounted) {
        await showCupertinoDialogWithOneAction(
          context,
          "Invalid session",
          "Seems like you are logged out, please log in again",
          Strings.ok,
          _goHome,
        );
      }
      return;
    }

    final result = await APIService().getWaiterSession(accessToken);

    if (!result.isSuccess) {
      await storage.delete(key: accessTokenKeyName);

      if (mounted) {
        await showCupertinoDialogWithOneAction(
          context,
          "Error",
          result.errorMessage!,
          Strings.ok,
          _goHome,
        );
      }
      return;
    }

    if (result.sessionMessage != null) {
      await storage.delete(key: accessTokenKeyName);

      if (mounted) {
        showCupertinoDialogWithOneAction(
          context,
          Strings.failTitle,
          result.sessionMessage!,
          Strings.ok,
          _goHome,
        );
      }
      return;
    }

    if (result.data != null) {
      await Future.wait([
        storage.write(key: accessTokenKeyName, value: result.data!.accessToken),
        storage.write(key: waiterNameKeyName, value: result.data!.name),
        storage.write(key: waiterEmailKeyName, value: result.data!.email),
      ]);
    }
  }

  void _goHome() {
    context.goNamed(ScreenNames.home.name);
  }

  void _openSettingsScreen() {
    context.goNamed(ScreenNames.waiterSettings.name);
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String activePageTitle = "Requests";

    if (_selectedPageIndex == 1) {
      activePageTitle = 'Ongoing orders';
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: RestazoAppBar(
        title: activePageTitle,
        leftNavigationIconAction: _openSettingsScreen,
        leftNavigationIconAsset: 'assets/setting.png',
      ),
      body: IndexedStack(
        index: _selectedPageIndex,
        children: _pages,
      ),
      bottomNavigationBar: RestazoBottomNavigationBar(
        leftItemAsset: "assets/message.png",
        leftItemLabel: "Requests",
        rightItemAsset: "assets/menu.png",
        rightItemLabel: "Ongoing orders",
        selectScreen: _selectScreen,
      ),
    );
  }
}
