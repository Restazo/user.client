import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/setting.dart';
import 'package:restazo_user_mobile/models/settings_section.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/settings_section.dart';

class WaiterModeSettingsScreen extends StatefulWidget {
  const WaiterModeSettingsScreen({super.key});

  @override
  State<WaiterModeSettingsScreen> createState() =>
      _WaiterModeSettingsScreenState();
}

class _WaiterModeSettingsScreenState extends State<WaiterModeSettingsScreen> {
  final storage = const FlutterSecureStorage();

  // Settings sections indexes
  static const int accountSectionIndex = 0;
  static const int signOutSectionIndex = 1;

  List<SettingsSection> settingsSections = [];
  late String waiterName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _initAllSettings();
  }

  Future<void> _initAllSettings() async {
    await _initAccountSettings();
    _initSignOutSettings();
  }

  Future<void> _initAccountSettings() async {
    final name =
        await storage.read(key: waiterNameKeyName) ?? Strings.noNameFound;
    final email =
        await storage.read(key: waiterEmailKeyName) ?? Strings.noEmailFound;

    List<Setting> accountSettings = [
      Setting(
        label: name,
      ),
      Setting(
        label: email,
      ),
    ];

    setState(() {
      settingsSections.insert(
          accountSectionIndex,
          SettingsSection(
              label: Strings.accountInfoTitle, settings: accountSettings));
    });
  }

  void _initSignOutSettings() {
    List<Setting> signOutSettings = [
      Setting(
        label: Strings.logOut,
        action: _confrimLogOut,
      )
    ];

    setState(() {
      settingsSections.insert(
          signOutSectionIndex,
          SettingsSection(
              label: Strings.actionsTitle, settings: signOutSettings));
    });
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
                      Strings.warningTitle,
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
                Strings.logOutWarningMessage,
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
                    Strings.cancel,
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
                    Strings.ok,
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

    await Future.wait([
      storage.delete(key: accessTokenKeyName),
      storage.delete(key: waiterNameKeyName),
      storage.delete(key: waiterEmailKeyName),
      APIService().logOutWaiter(accessToken)
    ]);

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
        title: Strings.settings,
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
            for (final settingsSectionInfo in settingsSections) ...[
              SettingsSectionUI(settingsSectionInfo: settingsSectionInfo),
              const SizedBox(height: 16)
            ]
          ],
        ),
      ),
    );
  }
}
