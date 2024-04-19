import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';

import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/strings.dart';

Future<void> openQrScanner(BuildContext context, bool mounted) async {
  final Location location = Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
  }

  if (permissionGranted == PermissionStatus.denied ||
      permissionGranted == PermissionStatus.deniedForever) {
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
