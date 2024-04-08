import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/providers/restaurants_near_you.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';

class Setting {
  const Setting({
    required this.label,
    required this.action,
    this.value,
    this.valueExtension,
  });

  final String label;
  final String? value;
  final void Function() action;
  final String? valueExtension;

  Setting copyWith({
    String? label,
    void Function()? action,
    String? value,
    String? valueExtension,
  }) {
    return Setting(
      label: label ?? this.label,
      action: action ?? this.action,
      value: value ?? this.value,
      valueExtension: valueExtension ?? this.valueExtension,
    );
  }
}

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

  @override
  void initState() {
    super.initState();

    settingsList = [
      Setting(label: 'Waiter mode', action: _goToWaterModeLoginScreen)
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

  Widget _buildSettingTile(Setting settingInfo) {
    final bool isFirst = settingsList.indexOf(settingInfo) == 0;
    final bool isLast =
        settingsList.indexOf(settingInfo) == settingsList.length - 1;

    return InkWell(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isFirst ? 10 : 0),
        topRight: Radius.circular(isFirst ? 10 : 0),
        bottomLeft: Radius.circular(isLast ? 10 : 0),
        bottomRight: Radius.circular(isLast ? 10 : 0),
      ),
      onTap: settingInfo.action,
      child: Padding(
        padding: const EdgeInsets.only(left: 36),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                right: 16,
                bottom: 16,
              ),
              child: Row(
                children: [
                  Text(
                    settingInfo.label,
                    style: _getMainInfotextstyle(),
                  ),
                  const Spacer(),
                  if (settingInfo.value != null)
                    Text(
                      settingInfo.value!,
                      style: _getSecondaryInfotextstyle(),
                    ),
                  if (settingInfo.value != null &&
                      settingInfo.valueExtension != null) ...[
                    Text(
                      settingInfo.valueExtension!,
                      style: _getSecondaryInfotextstyle(),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Image.asset(
                    'assets/right.png',
                    height: 16,
                    width: 16,
                    color: _getSecondaryInfoColor(),
                  )
                ],
              ),
            ),
            if (!isLast)
              Container(
                height: 1,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 125, 125, 125),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
              )
          ],
        ),
      ),
    );
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
          cancelButton: TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color.fromARGB(255, 200, 200, 200);
                  }
                  return null;
                },
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  // const Color.fromARGB(255, 29, 39, 42)),
                  const Color.fromARGB(255, 255, 255, 255)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(12)),
            ),
            child: Text("Cancel",
                style: _getMainInfotextstyle().copyWith(
                  color: Colors.black,
                )),
            onPressed: () {
              pickingCanceled = true;

              context.pop();
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        // backgroundColor: const Color.fromARGB(255, 29, 39, 42),
        itemExtent: 48,
        onSelectedItemChanged: (index) {
          selectedRangeIndex = index;
        },
        children: rangePickerItems
            .map((item) => Center(
                    child: Text(
                  '${item}km',
                  style: _getMainInfotextstyle().copyWith(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                )))
            .toList(),
      ),
    );
  }

  void _goBack() {
    navigateBack(context);
  }

  void _goToWaterModeLoginScreen() {
    context.goNamed(ScreenNames.waiterModeLogin.name);
  }

  Color _getSecondaryInfoColor() {
    return const Color.fromARGB(255, 186, 186, 186);
  }

  Color _getMainInfoColor() {
    return const Color.fromARGB(255, 255, 255, 255);
  }

  TextStyle _getSecondaryInfotextstyle() {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: _getSecondaryInfoColor(),
          letterSpacing: 0,
        );
  }

  TextStyle _getMainInfotextstyle() {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: _getMainInfoColor(),
          letterSpacing: 0,
        );
  }

  @override
  void dispose() {
    rangeSetterScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Settings',
        leftNavigationIconAction: _goBack,
        leftNavigationIconAsset: 'assets/left.png',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 36,
        ),
        child: Material(
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
                  _buildSettingTile(settingInfo)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
