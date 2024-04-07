import 'package:flutter/material.dart';

class SnackBarWithAction {
  static SnackBar create({
    required Widget content,
    required VoidCallback actionFunction,
    required String actionLabel,
  }) {
    return SnackBar(
      content: content,
      duration: const Duration(minutes: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      backgroundColor: const Color.fromARGB(255, 22, 32, 35),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: actionLabel,
        onPressed: actionFunction,
        textColor: Colors.green,
      ),
    );
  }
}
