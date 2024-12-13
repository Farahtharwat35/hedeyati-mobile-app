import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/app/reusable_components/app_bar.dart';
import 'package:hedeyati/app/home/home_page.dart';
import 'package:hedeyati/app/notification/notifications_page.dart';
import 'package:hedeyati/app/event/main_events_page.dart';
import 'package:hedeyati/bloc/events/event_bloc.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_bloc.dart';

import '../../bloc/gift_category/gift_category_events.dart';


class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    print("??");
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Hedeyati'),
        body: TabBarView(
          children: <Widget>[
            const HomePage(),
            BlocProvider(
              create: (_) => EventBloc(),
              child: EventsPage(),
            ),
            const NotificationPage(),
          ],
        ),
      ),
    );
  }
}
