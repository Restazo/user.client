import 'package:flutter/material.dart';

TextButton buildCancelButton({
  required BuildContext context,
  required void Function() onPressed,
}) {
  return TextButton(
    style: ButtonStyle(
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return const Color.fromARGB(255, 200, 200, 200);
          }
          return null;
        },
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 255, 255, 255)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
    ),
    onPressed: onPressed,
    child: Text(
      "Cancel",
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: const Color.fromARGB(255, 255, 59, 47),
            letterSpacing: 0,
          ),
    ),
  );
}
