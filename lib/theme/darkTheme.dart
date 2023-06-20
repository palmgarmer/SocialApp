import 'package:flutter/material.dart';

// dark theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[800]!,
    surface: Colors.grey[500]!,
    onSurface: Colors.grey[300]!,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.white),
  ),
);
