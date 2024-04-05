import 'package:flutter/material.dart';

class AffordabilityRow extends StatelessWidget {
  const AffordabilityRow({
    super.key,
    required this.affordability,
    required this.fontSize,
  });

  final int affordability;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "\$",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: affordability >= 1
                  ? Colors.white
                  : const Color.fromARGB(255, 144, 144, 144),
              fontSize: fontSize),
        ),
        Text(
          "\$",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: affordability >= 2
                  ? Colors.white
                  : const Color.fromARGB(255, 144, 144, 144),
              fontSize: fontSize),
        ),
        Text(
          "\$",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: affordability == 3
                  ? Colors.white
                  : const Color.fromARGB(255, 144, 144, 144),
              fontSize: fontSize),
        ),
      ],
    );
  }
}
