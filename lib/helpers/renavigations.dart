import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restazo_user_mobile/router/app_router.dart';

void openQrScanner(BuildContext context) {
  context.goNamed(ScreenNames.qrScanner.name);
}

void navigateBack(BuildContext context) {
  context.pop();
}
