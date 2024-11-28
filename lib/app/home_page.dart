import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import 'package:hedeyati/app/home_page_body.dart';
import '../add_friend.dart';
import '../search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          MySearchBar(),
          Expanded(child:
          FriendsListWidget())
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        foregroundColor: myTheme.colorScheme.onPrimary,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.person_add),
            label: 'Add Friend',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddFriendPage()));
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.event),
            label: 'Add event',
            onTap: () {
            },
          ),
        ],

      ),
    );
  }
}