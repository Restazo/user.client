import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';

Future<bool> checkDeviceIdExistence() async {
  const storage = FlutterSecureStorage();

  final deviceId = await storage.read(key: deviceIdKeyName);

  if (deviceId == null) {
    final deviceIdState = await APIService().getDeviceId();

    if (deviceIdState.isSuccess) {
      await storage.write(
          key: deviceIdKeyName, value: deviceIdState.data!.deviceId);

      return true;
    }

    return false;
  }

  return true;
}
