import 'package:flutter/material.dart';
import 'package:hedeyati/app_bar.dart';
import 'package:hedeyati/home_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  // final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FriendsListWidget(),
    );
  }
}