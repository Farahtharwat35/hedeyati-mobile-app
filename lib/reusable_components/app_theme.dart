import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  primarySwatch: Colors.pink,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.pink,
  ).copyWith(
    surface: Colors.white60, // Light gray with opacity for surface
  ),
  fontFamily: 'GreatVibes', // Set a default font family
  hintColor: Colors.green,

  // Modern button theme usage
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.pink, // Button text color
      backgroundColor: Colors.pinkAccent, // Button background color
      shadowColor: Colors.black45,
    ),
  ),

  // Deprecated ButtonThemeData removed
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(color: Colors.black54, fontSize: 16.0),
  ),
);
