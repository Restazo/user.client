import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCupertinoDialogWithThreeActions(
  BuildContext context,
  String title,
  String message,
  String topActionText,
  void Function() topAction,
  String middleActionText,
  void Function() middleAction,
  String bottomActionText,
  void Function() bottomAction,
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
            onPressed: topAction,
            child: Text(
              topActionText,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black),
            ),
          ),
          CupertinoDialogAction(
            onPressed: middleAction,
            child: Text(
              middleActionText,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black),
            ),
          ),
          CupertinoDialogAction(
            onPressed: bottomAction,
            child: Text(
              bottomActionText,
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
