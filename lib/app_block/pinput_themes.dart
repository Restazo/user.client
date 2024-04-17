import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

final defaultPinTheme = PinTheme(
  width: 45,
  height: 45,
  textStyle: const TextStyle(
    fontSize: 20,
    color: Colors.white,
  ),
  decoration: BoxDecoration(
    border: Border.all(
      color: const Color.fromARGB(255, 107, 114, 116),
      width: 1,
    ),
    borderRadius: BorderRadius.circular(5),
  ),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(
    color: Colors.white,
    width: 2,
  ),
);

final submittedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: Colors.white),
);

final errorPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: const Color.fromARGB(255, 255, 59, 47)),
);
