import 'package:flutter/material.dart';

import 'package:restazo_user_mobile/models/setting.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.settingInfo,
  });

  final Setting settingInfo;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isFirst ? 10 : 0),
        topRight: Radius.circular(isFirst ? 10 : 0),
        bottomLeft: Radius.circular(isLast ? 10 : 0),
        bottomRight: Radius.circular(isLast ? 10 : 0),
      ),
      onTap: settingInfo.action,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
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
                  Expanded(
                    child: Text(
                      settingInfo.label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            letterSpacing: 0,
                          ),
                    ),
                  ),
                  if (settingInfo.value != null) ...[
                    const Spacer(),
                    Text(
                      textAlign: TextAlign.end,
                      settingInfo.value!,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 186, 186, 186),
                            letterSpacing: 0,
                          ),
                    ),
                  ],
                  if (settingInfo.value != null &&
                      settingInfo.valueExtension != null)
                    Text(
                      settingInfo.valueExtension!,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color.fromARGB(255, 186, 186, 186),
                            letterSpacing: 0,
                          ),
                    ),
                  if (settingInfo.value != null && settingInfo.action != null)
                    const SizedBox(width: 12),
                  if (settingInfo.action != null)
                    Image.asset(
                      'assets/right.png',
                      height: 16,
                      width: 16,
                      color: const Color.fromARGB(255, 186, 186, 186),
                    )
                ],
              ),
            ),
            if (!isLast)
              Container(
                height: 0.2,
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
}
