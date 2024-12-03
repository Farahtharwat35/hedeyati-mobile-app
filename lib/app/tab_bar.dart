import 'package:flutter/material.dart';
import 'package:hedeyati/app/reusable_components/app_bar.dart';
import 'package:hedeyati/app/home_page.dart';
import 'package:hedeyati/app/notifications_page.dart';

import 'main_events_page.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(title: 'Hedeyati'),
        body: TabBarView(
          children: <Widget>[
            HomePage(),
            EventsPage(),
            NotificationPage(),
          ],
        ),
      ),
    );
  }
}