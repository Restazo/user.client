import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/setting.dart';
import 'package:restazo_user_mobile/widgets/setting_tile.dart';
import 'package:restazo_user_mobile/helpers/cancel_button.dart';
import 'package:restazo_user_mobile/widgets/waiter_log_in.dart';
import 'package:restazo_user_mobile/widgets/waiter_log_in_confirmation.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/providers/restaurants_near_you.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late SharedPreferences preferences;
  int selectedRangeIndex = 0;
  List<Setting> settingsList = [];
  late FixedExtentScrollController rangeSetterScrollController;
  List<String> rangePickerItems = List.generate(
    (500 - 25) ~/ 25 + 1,
    (index) => '${25 + index * 25}',
  );
  final String searchRangeKeyName = dotenv.env['USER_SEARCH_RANGE_KEY_NAME']!;
  String waiterEmail = '';
  bool waiterLogInSubmitted = false;

  @override
  void initState() {
    super.initState();

    settingsList = [
      Setting(
        label: 'Waiter mode',
        action: _showWaiterLogIn,
      )
    ];

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
          settingsList.insert(
            0,
            Setting(
              label: 'Search range',
              action: _showRangePicker,
              value: range,
              valueExtension: 'km',
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
    final int settingIndex =
        settingsList.indexWhere((setting) => setting.label == 'Search range');

    Setting updatedSetting = settingsList[settingIndex]
        .copyWith(value: rangePickerItems[pickerItemIndex]);

    selectedRangeIndex = pickerItemIndex;

    setState(() {
      settingsList[settingIndex] = updatedSetting;
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
                  '${item}km',
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
          return;
        }

        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                  "Fail",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                content: Text(
                  result.errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black,
                      ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("Ok"),
                    onPressed: () {
                      _goBack();
                    },
                  )
                ],
              );
            },
          );
        }
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
        title: 'Settings',
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
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
