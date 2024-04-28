import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showCupertinoDialogWithOneAction(
  BuildContext context,
  String title,
  String message,
  String actionText,
  void Function() action,
) async {
  await showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black,
              ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: action,
            child: Text(
              actionText,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
