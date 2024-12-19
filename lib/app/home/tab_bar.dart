import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/app/reusable_components/app_bar.dart';
import 'package:hedeyati/app/home/home_page.dart';
import 'package:hedeyati/app/notification/notifications_page.dart';
import 'package:hedeyati/app/event/main_events_page.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import 'package:hedeyati/bloc/events/event_bloc.dart';
import 'package:hedeyati/bloc/friendship/friendship_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/bloc/notification/notification_bloc.dart';
import 'package:hedeyati/bloc/user/user_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../bloc/generic_bloc/generic_crud_events.dart';
import '../../models/notification.dart' as NotificationModel;
import '../reusable_components/build_card.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({Key? key}) : super(key: key);

  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  @override
  void initState() {
    super.initState();
  }

  void _markNotificationsAsRead(List<NotificationModel.Notification> notifications) {
    for (var notification in notifications) {
      if (!notification.isRead) {
        context.read<NotificationBloc>().add(UpdateModel(notification.copyWith(isRead: true)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, ModelStates>(
      builder: (context, state) {
        return AsyncBuilder<List<NotificationModel.Notification>>(
          stream: context.read<NotificationBloc>().nonSeenNotificationStream,
          builder: (context, notifications) {
            if (notifications != null && notifications.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                List<Widget> content = [];
                content.addAll(notifications.map((e) => Center(child: Text(e.title , style: myTheme.textTheme.headlineMedium))).toList());
                content.addAll(notifications.map((e) => Center(child: Text(e.body , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.pinkAccent)))).toList());

                showOverlayNotification(
                      duration: const Duration(seconds: 6),
                      (context) => buildCard(context, content),
                );

                _markNotificationsAsRead(notifications);
              });
            }
            return DefaultTabController(
              initialIndex: 0,
              length: 3,
              child: Scaffold(
                appBar: const CustomAppBar(title: 'Hedeyati'),
                body: TabBarView(
                  children: <Widget>[
                    const HomePage(),
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(create: (_) => EventBloc()..initializeStreams()),
                        BlocProvider(create: (_) => UserBloc()),
                      ],
                      child: EventsPage(),
                    ),
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(create: (_) => NotificationBloc()..initializeStreams()),
                        BlocProvider(create: (_) => UserBloc()),
                        BlocProvider(
                          create: (_) => FriendshipBloc(userID:FirebaseAuth.instance.currentUser!.uid)..initializeStreams(),
                          lazy: false,
                        ),
                      ],
                      child: const NotificationPage(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
