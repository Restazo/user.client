import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/setting.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/setting_tile.dart';

class WaiterModeSettingsScreen extends StatefulWidget {
  const WaiterModeSettingsScreen({super.key});

  @override
  State<WaiterModeSettingsScreen> createState() =>
      _WaiterModeSettingsScreenState();
}

class _WaiterModeSettingsScreenState extends State<WaiterModeSettingsScreen> {
  final storage = const FlutterSecureStorage();
  List<Setting> settingsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    settingsList = [
      Setting(
        label: 'Log out',
        action: _confrimLogOut,
      )
    ];
  }

  void _confrimLogOut() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Widget dialogTitle = !_isLoading
                ? KeyedSubtree(
                    key: const ValueKey('warning_title_text'),
                    child: Text(
                      "Warning",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
                : KeyedSubtree(
                    key: const ValueKey("loading_dialog_title"),
                    child: LoadingAnimationWidget.dotsTriangle(
                        color: Colors.black, size: 24),
                  );

            return CupertinoAlertDialog(
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: dialogTitle,
              ),
              content: Text(
                "You will get logged out by this action",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                    ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: !_isLoading
                      ? () {
                          context.pop();
                        }
                      : null,
                  child: Text(
                    "Cancel",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black),
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: !_isLoading
                      ? () async {
                          await _logOut(setDialogState);
                        }
                      : null,
                  child: Text(
                    "OK",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _logOut(void Function(void Function()) setDialogState) async {
    setDialogState(() {
      _isLoading = true;
    });
    final accessToken = await storage.read(key: accessTokenKeyName);

    if (accessToken == null) {
      setDialogState(() {
        _isLoading = false;
      });
      if (mounted) {
        context.goNamed(ScreenNames.home.name);
      }
      return;
    }

    await storage.delete(key: accessTokenKeyName);
    await APIService().logOutWaiter(accessToken);

    setDialogState(() {
      _isLoading = false;
    });
    if (mounted) {
      context.goNamed(ScreenNames.home.name);
    }
  }

  void _goBack() {
    navigateBack(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: RestazoAppBar(
        leftNavigationIconAsset: "assets/left.png",
        leftNavigationIconAction: _goBack,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 36,
        ),
        child: ListView(
          children: [
            Material(
              borderRadius: BorderRadius.circular(10),
              child: Ink(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 29, 39, 42),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final settingInfo in settingsList)
                      SettingTile(
                        settingInfo: settingInfo,
                        isFirst: settingsList.indexOf(settingInfo) == 0,
                        isLast: settingsList.indexOf(settingInfo) ==
                            settingsList.length - 1,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
