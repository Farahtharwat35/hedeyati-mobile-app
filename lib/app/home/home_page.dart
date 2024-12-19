import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import 'package:hedeyati/app/home/home_page_body.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_bloc.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_events.dart';
import 'package:hedeyati/bloc/gifts/gift_bloc.dart';
import 'package:hedeyati/bloc/user/user_bloc.dart';
import '../../bloc/friendship/friendship_bloc.dart';
import '../../bloc/notification/notification_bloc.dart';
import '../friends/add_friend.dart';
import '../gift/add_gift.dart';
import '../home/search_bar.dart';
import '../../bloc/events/event_bloc.dart';
import '../event/add_event_page.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GiftCategoryBloc>(
      lazy: false,
      create: (_) {
        return GiftCategoryBloc()..add(LoadGiftCategoriesEventToLocalDatabase());
      },
      child: BlocBuilder<GiftCategoryBloc, ModelStates>(
        builder: (context, state) => Scaffold(
          body: Column(
            children: [const MySearchBar(), MultiBlocProvider(providers: [
            BlocProvider<FriendshipBloc>(
              lazy: false,
              create: (_) => FriendshipBloc(userID: FirebaseAuth.instance.currentUser!.uid)..initializeStreams(),
            ),
            BlocProvider<EventBloc>(
              lazy: false,
              create: (_) => EventBloc()..initializeStreams(),
            ),
            ],
            child: Expanded(child: FriendsList())),
            ],
          ),
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            foregroundColor: myTheme.colorScheme.onPrimary,
            children: [
              SpeedDialChild(
                backgroundColor: myTheme.colorScheme.secondary,
                child: const Icon(Icons.person_add),
                label: 'Add Friend',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider<FriendshipBloc>(
                              lazy: false,
                              create: (_) => FriendshipBloc(userID:FirebaseAuth.instance.currentUser!.uid)..initializeStreams(),
                            ),
                            BlocProvider<UserBloc>(
                              lazy: false,
                              create: (_) => UserBloc(),
                            ),
                            BlocProvider<NotificationBloc>(
                              lazy: false,
                              create: (_) => NotificationBloc()..initializeStreams(),
                            ),
                          ],
                          child: AddFriendPage())));
                },
              ),
              SpeedDialChild(
                backgroundColor: myTheme.colorScheme.secondary,
                child: const Icon(Icons.event),
                label: 'Add Event',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider<EventBloc>(
                        create: (_) => EventBloc(),
                        child: const CreateEventPage(),
                        ),
                      ),
                  );
                },
              ),
              SpeedDialChild(
                backgroundColor: myTheme.colorScheme.secondary,
                child: const Icon(Icons.card_giftcard),
                label: 'Add Gift',
                onTap: () {
                  final giftCategoryBloc =
                  BlocProvider.of<GiftCategoryBloc>(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiProvider(
                        providers: [
                          Provider<GiftBloc>(
                            create: (_) => GiftBloc(),
                          ),
                          Provider<EventBloc>(
                            create: (_) => EventBloc(),
                          ),
                        ],
                        child: BlocProvider.value(
                          value: giftCategoryBloc,
                          child: const AddGift(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
