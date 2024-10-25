import 'package:flutter/material.dart';
import 'package:hedeyati/login_page.dart';
import 'package:hedeyati/tab_bar.dart';
import 'package:hedeyati/app_theme.dart';

void main() {
  runApp(const Hedeyati());
}

class Hedeyati extends StatelessWidget {
  const Hedeyati({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedeyati',
      theme: myTheme,
      home: LoginPage(),
    );
  }
}
