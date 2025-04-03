import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF00B57A), // Keep green
    onPrimary: Colors.white,
    secondary: Color(0xFF00B57A), // Keep green
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00B57A), // Keep green
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black54),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF00B57A), // Keep green
    textTheme: ButtonTextTheme.primary,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF00B57A), // Keep green
    onPrimary: Colors.black,
    secondary: Color(0xFF00B57A), // Keep green
    onSecondary: Colors.black,
    surface: Colors.black,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00B57A), // Keep green
    foregroundColor: Colors.black,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white70),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF00B57A), // Keep green
    textTheme: ButtonTextTheme.primary,
  ),
);