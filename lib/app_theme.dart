import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  hintColor: Colors.green,
  buttonTheme: ButtonThemeData(buttonColor: Colors.blue),
  textTheme: TextTheme(
    headlineMedium: TextStyle(fontSize: 2000, fontWeight: FontWeight.bold, fontFamily: 'GreatVibes'),
    bodyMedium: TextStyle(fontSize: 16.0),
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
    surface: Colors.white
  ),
);