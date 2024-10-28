import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  useMaterial3: true,
  hintColor: Colors.pinkAccent,
  buttonTheme: const ButtonThemeData(buttonColor: Colors.pinkAccent),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.pink,
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'GreatVibes'),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'GreatVibes'),
    bodyMedium: TextStyle(fontSize: 16.0 , fontFamily: "Times New Roman") ,
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
    primary: Colors.pink,
    surface: Colors.white70,
    secondary: Colors.white,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.black,
    unselectedLabelColor: Colors.black,
  ),
  listTileTheme: const ListTileThemeData(
    selectedTileColor: Colors.pinkAccent,
  ),

);