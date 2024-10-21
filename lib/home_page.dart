import 'package:flutter/material.dart';
import 'package:hedeyati/reusable_components/app_bar.dart';
import 'package:hedeyati/home_page_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Hedeyati'),
      body: FriendsListWidget(),
    );
  }
}