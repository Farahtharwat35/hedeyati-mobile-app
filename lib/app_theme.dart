import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  useMaterial3: true,
  hintColor: Colors.pinkAccent,
  buttonTheme: const ButtonThemeData(buttonColor: Colors.pinkAccent),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'GreatVibes'),
    bodyMedium: TextStyle(fontSize: 16.0 , fontFamily: "Times New Roman") ,
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
    surface: Colors.white,
  ),

);