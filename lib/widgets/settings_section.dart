import 'package:flutter/material.dart';
import 'package:restazo_user_mobile/models/settings_section.dart';
import 'package:restazo_user_mobile/widgets/setting_tile.dart';

class SettingsSectionUI extends StatelessWidget {
  const SettingsSectionUI({super.key, required this.settingsSectionInfo});
  final SettingsSection settingsSectionInfo;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              settingsSectionInfo.label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: const Color.fromARGB(255, 186, 186, 186)),
            ),
          ),
          const SizedBox(height: 8),
          Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 29, 39, 42),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final settingInfo in settingsSectionInfo.settings)
                  SettingTile(
                    settingInfo: settingInfo,
                    isFirst:
                        settingsSectionInfo.settings.indexOf(settingInfo) == 0,
                    isLast: settingsSectionInfo.settings.indexOf(settingInfo) ==
                        settingsSectionInfo.settings.length - 1,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
