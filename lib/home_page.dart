import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hedeyati/app_theme.dart';
import 'package:hedeyati/search_bar.dart';
import 'package:hedeyati/home_page_body.dart';

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
      body: Column(
        children: [
          MySearchBar(),
          Expanded(child: FriendsListWidget())
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        foregroundColor: myTheme.colorScheme.onPrimary,
        children: [
          SpeedDialChild(
            child: Icon(Icons.person_add),
            label: 'Add Friend',
            onTap: () {
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.event),
            label: 'Add event',
            onTap: () {
            },
          ),
        ],

      ),
    );
  }
}