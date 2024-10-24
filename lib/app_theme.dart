import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  useMaterial3: true,
  hintColor: Colors.green,
  buttonTheme: const ButtonThemeData(buttonColor: Colors.blue),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'GreatVibes'),
    bodyMedium: TextStyle(fontSize: 16.0),
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
    surface: Colors.white,
  ),

);