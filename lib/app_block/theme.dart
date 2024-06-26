import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color.fromARGB(255, 4, 15, 18),
  textTheme: GoogleFonts.istokWebTextTheme(),
  splashColor: const Color.fromARGB(12, 255, 255, 255),
  highlightColor: const Color.fromARGB(12, 255, 255, 255),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Color.fromARGB(255, 255, 255, 255),
    unselectedItemColor: Color.fromARGB(255, 144, 144, 144),
    backgroundColor: Colors.transparent,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor:
        Color.fromARGB(65, 255, 255, 255), // Color used for text selection
    selectionHandleColor:
        Colors.black, // Color of the handles at the edges of selection
    cursorColor: Colors.white, // Color of the cursor
  ),
);
