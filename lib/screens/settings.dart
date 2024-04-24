import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/models/settings_section.dart';
import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/widgets/settings_section.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/setting.dart';
import 'package:restazo_user_mobile/helpers/cancel_button.dart';
import 'package:restazo_user_mobile/widgets/waiter_log_in.dart';
import 'package:restazo_user_mobile/widgets/waiter_log_in_confirmation.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/providers/restaurants_near_you_provider.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late SharedPreferences preferences;
  int selectedRangeIndex = 0;
  List<SettingsSection> settingsSections = [];

  // Settings sections indexes
  static const int generalSectionIndex = 0;

  late FixedExtentScrollController rangeSetterScrollController;
  List<String> rangePickerItems = List.generate(
    (500 - 25) ~/ 25 + 1,
    (index) => '${25 + index * 25}',
  );
  String waiterEmail = '';
  bool waiterLogInSubmitted = false;

  @override
  void initState() {
    super.initState();

    List<Setting> generalSettings = [
      Setting(
        label: Strings.waiterModeSettingTitle,
        action: _showWaiterLogIn,
      )
    ];

    settingsSections.insert(generalSectionIndex,
        SettingsSection(label: Strings.general, settings: generalSettings));

    WidgetsBinding.instance.addPostFrameCallback((_) => _initPreferences());
  }

  Future<void> _initPreferences() async {
    preferences = await SharedPreferences.getInstance();

    String range = await getSearchRange();

    selectedRangeIndex = rangePickerItems.indexOf(range);

    if (selectedRangeIndex == -1) selectedRangeIndex = 0;

    rangeSetterScrollController =
        FixedExtentScrollController(initialItem: selectedRangeIndex);

    Future.microtask(() => setState(() {
          settingsSections[generalSectionIndex].settings.insert(
                0,
                Setting(
                  label: Strings.searchRangeSettingTitle,
                  action: _showRangePicker,
                  value: range,
                  valueExtension: Strings.kilometersExtension,
                ),
              );
        }));
  }

  Future<String> getSearchRange() async {
    String? range = preferences.getString(searchRangeKeyName);
    if (range == null) {
      range = '100';
      await preferences.setString(searchRangeKeyName, range);
    }

    return range;
  }

  Future<void> _selectRange(int pickerItemIndex) async {
    final int settingIndex = settingsSections[0].settings.indexWhere(
        (setting) => setting.label == Strings.searchRangeSettingTitle);

    Setting updatedSetting = settingsSections[0]
        .settings[settingIndex]
        .copyWith(value: rangePickerItems[pickerItemIndex]);

    selectedRangeIndex = pickerItemIndex;

    setState(() {
      settingsSections[0].settings[settingIndex] = updatedSetting;
      rangeSetterScrollController.jumpToItem(pickerItemIndex);
    });

    ref.read(restaurantsNearYouProvider.notifier).loadRestaurantsNearYou();

    preferences.setString(
        searchRangeKeyName, rangePickerItems[pickerItemIndex]);
  }

  void _showRangePicker() {
    rangeSetterScrollController.dispose();
    rangeSetterScrollController =
        FixedExtentScrollController(initialItem: selectedRangeIndex);
    bool pickingCanceled = false;

    int preservedRangeIndex = selectedRangeIndex;

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [_buildCupertinoPicker()],
          cancelButton: buildCancelButton(
            context: context,
            onPressed: () {
              pickingCanceled = true;

              _goBack();
            },
          ),
        );
      },
    ).then((_) {
      if (preservedRangeIndex != selectedRangeIndex) {
        if (pickingCanceled) {
          return _selectRange(preservedRangeIndex);
        }

        _selectRange(selectedRangeIndex);
      }
    });
  }

  Widget _buildCupertinoPicker() {
    return SizedBox(
      height: 256,
      child: CupertinoPicker(
        scrollController: rangeSetterScrollController,
        backgroundColor: const Color.fromARGB(255, 29, 39, 42),
        itemExtent: 48,
        onSelectedItemChanged: (index) {
          selectedRangeIndex = index;
        },
        children: rangePickerItems
            .map(
              (item) => Center(
                child: Text(
                  '$item${Strings.kilometersExtension}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      letterSpacing: 0,
                      fontSize: 20),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _showWaiterLogIn() {
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            Widget action = waiterLogInSubmitted
                ? KeyedSubtree(
                    key: const ValueKey(
                        'waiter_login_confirmation_modal_contents'),
                    child: _buildWaiterModeConfirmation(),
                  )
                : KeyedSubtree(
                    key: const ValueKey('waiter_login_modal_contents'),
                    child: _buildWaiterModeLogIn(setModalState),
                  );

            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: CupertinoActionSheet(
                actions: [
                  Container(
                    color: const Color.fromARGB(255, 29, 39, 42),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        alignment: Alignment.bottomCenter,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          layoutBuilder: (Widget? currentChild,
                              List<Widget> previousChildren) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                ...previousChildren,
                                if (currentChild != null) currentChild,
                              ],
                            );
                          },
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: action,
                        ),
                      ),
                    ),
                  ),
                ],
                cancelButton: buildCancelButton(
                  context: context,
                  onPressed: () {
                    _goBack();
                  },
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      waiterLogInSubmitted = false;
      waiterEmail = '';
    });
  }

  Widget _buildWaiterModeLogIn(void Function(void Function()) setModalState) {
    return WaiterLogInPopUp(
      submitWaiterLogIn: (String submitedWaiterEmail, String pinCode) async {
        final result =
            await APIService().logInWaiter(submitedWaiterEmail, pinCode);

        if (result.isSuccess) {
          waiterEmail = submitedWaiterEmail;
          setModalState(() {
            waiterLogInSubmitted = true;
          });
          return true;
        }

        if (mounted) {
          showCupertinoDialogWithOneAction(context, Strings.failTitle,
              result.errorMessage!, Strings.ok, _goBack);
        }
        return false;
      },
    );
  }

  Widget _buildWaiterModeConfirmation() {
    return WaiterLogInConfirmation(waiterEmail: waiterEmail);
  }

  void _goBack() {
    navigateBack(context);
  }

  @override
  void dispose() {
    rangeSetterScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: RestazoAppBar(
        title: Strings.settings,
        leftNavigationIconAction: _goBack,
        leftNavigationIconAsset: 'assets/left.png',
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
