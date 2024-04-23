import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:restazo_user_mobile/helpers/check_device_id_existence.dart';
import 'package:restazo_user_mobile/helpers/check_location_permissions.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/strings.dart';

Future<void> openQrScanner(BuildContext context, bool mounted) async {
  final deviceIdExists = await checkDeviceIdExistence();
  if (!deviceIdExists) {
    if (mounted) {
      return showCupertinoDialogWithOneAction(
          // ignore: use_build_context_synchronously
          context,
          Strings.unexpectedErrorTitle,
          Strings.checkInternetConnectionMessage,
          Strings.ok, () {
        navigateBack(context);
      });
    }
  }

  final locationPermissionGranted = await checkLocationPermissions();

  if (!locationPermissionGranted) {
    if (mounted) {
      return showCupertinoDialogWithOneAction(
          // ignore: use_build_context_synchronously
          context,
          Strings.lackOfPermissionsTitle,
          Strings.enableLocationMessage,
          Strings.ok, () {
        navigateBack(context);
      });
    }
  }
  if (mounted) {
    // ignore: use_build_context_synchronously
    context.goNamed(ScreenNames.qrScanner.name);
  }
}

void navigateBack(BuildContext context) {
  context.pop();
}
