import 'package:flutter/material.dart';

// light theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.grey[100]!,
    secondary: Colors.grey[200]!,
    surface: Colors.white,
    onSurface: Colors.grey[700]!,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.black),
  ),
);
