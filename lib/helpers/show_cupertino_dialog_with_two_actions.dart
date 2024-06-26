import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCupertinoDialogWithTwoActions(
  BuildContext context,
  String title,
  String message,
  String leftActionText,
  void Function() leftAction,
  String rightActionText,
  void Function() rightAction,
) {
  showCupertinoDialog(
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
            onPressed: leftAction,
            child: Text(
              leftActionText,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black),
            ),
          ),
          CupertinoDialogAction(
            onPressed: rightAction,
            child: Text(
              rightActionText,
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
