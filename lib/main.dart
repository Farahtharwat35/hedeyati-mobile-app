import 'package:flutter/material.dart';
import 'package:hedeyati/login_page.dart';
import 'package:hedeyati/reusable_components/app_theme.dart';

void main() {
  runApp(const Hedeyati());
}

class Hedeyati extends StatelessWidget {
  const Hedeyati({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedeyati',
      theme: myTheme,
      home: const LoginPage(),
    );
  }
}
