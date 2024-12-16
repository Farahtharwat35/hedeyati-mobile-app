import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/app/reusable_components/app_bar.dart';
import 'package:hedeyati/app/home/home_page.dart';
import 'package:hedeyati/app/notification/notifications_page.dart';
import 'package:hedeyati/app/event/main_events_page.dart';
import 'package:hedeyati/bloc/events/event_bloc.dart';
import 'package:hedeyati/bloc/notification/notification_bloc.dart';
import 'package:hedeyati/bloc/user/user_bloc.dart';



class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
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
            MultiBlocProvider
              ( providers: [
                BlocProvider(create: (_) => NotificationBloc()..initializeStreams()),
                BlocProvider(create: (_) => UserBloc()),
            ],
                child: const NotificationPage()),
          ],
        ),
      ),
    );
  }
}
