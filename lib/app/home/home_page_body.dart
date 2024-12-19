import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import 'package:hedeyati/bloc/friendship/frienship_events.dart';
import 'package:hedeyati/helpers/listFiltering.dart';
import 'package:hedeyati/models/user.dart' as User;
import '../../bloc/events/event_bloc.dart';
import '../../bloc/friendship/friendship_bloc.dart';
import '../../bloc/generic_bloc/generic_states.dart';
import '../../models/event.dart';
import '../../models/friendship.dart';
import '../../models/user.dart';
import '../reusable_components/build_card.dart';

List<int> numbers = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20
];

int generate_random_number() {
  return numbers[math.Random().nextInt(numbers.length)];
}

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  String userID = FirebaseAuth.instance.currentUser!.uid;
  List<Friendship> friendships = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<List<Friendship>>(
      stream: context.read<FriendshipBloc>().myFriendsStream,
      error: (context, error, stackTrace) {
        log("Error fetching friendships: $error");
        return Center(child: Text('Error: $error'));
      },
      waiting: (context) {
        log("Waiting for friendships...");
        return const Center(child: CircularProgressIndicator());
      },
      builder: (context, friendships) {
        if (friendships != null && friendships.isNotEmpty) {
          log("Friendships loaded: ${friendships.length}");
          context.read<FriendshipBloc>().add(
              GetMyFriendsList(userID: userID, friendships: friendships));
          return BlocBuilder<FriendshipBloc, ModelStates>(
            builder: (context, userState) {
              if (userState is ModelLoadedState) {
                return AsyncBuilder<List<Event>>(
                  stream: context.read<EventBloc>().friendsEventsStream,
                  builder: (context, events) {
                    List<Widget> friendWidgets = [
                      Center(child: Text('Friends', style: myTheme.textTheme.headlineMedium))
                    ];
                    for (User.User user in userState.models as List<User.User>) {
                      log("Building widget for user: ${user.username}");

                      friendWidgets.add(_buildFriendsTile(context, user , events?? []));
                    }
                    return buildCard(context, friendWidgets);
                  },
                );
              } else {
                return buildCard(context, [
                  Center(child: Text('Friends', style: myTheme.textTheme.headlineMedium)),
                  Center(child: Text("No friends found."))
                ]);
              }
            },
          );
        } else {
          log("No friendships found.");
          return buildCard(context, [
            Center(child: Text('Friends', style: myTheme.textTheme.headlineMedium)),
            Center(child: Text("No friends found."))
          ]);
        }
      },
    );
  }

  Widget _buildFriendsTile(BuildContext context, User.User user , List<Event> events) {
    List<Event> upcomingEvents = filterList(events, (event) => event.createdAt!.isAfter(DateTime.now()) && event.firestoreUserID == user.id);
    return ListTile(
      leading: user.avatar != null
          ? CircleAvatar(
        backgroundImage: NetworkImage(user.avatar!),
      )
          : CircleAvatar(
        backgroundColor: Colors.pinkAccent,
        child: Text(
          user.username[0],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),

    trailing: upcomingEvents.isNotEmpty
        ? CircleAvatar(
          radius: 12,
          backgroundColor: Colors.white,
          child: Text(
                '${upcomingEvents.length}',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
        )
        : const SizedBox(),
      title: Text(
        user.username,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: myTheme.textTheme.bodyMedium!.color,
        ),
      ),
      subtitle: Text(
        'Tap to view details',
        style: TextStyle(color: Colors.grey[600]),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(user: user),
          ),
        );
      },
    );
  }
}


class DetailPage extends StatelessWidget {
  final User.User user;

  const DetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 70, 0),
          child: Center(child: Text(user.username)),
        ),
        titleTextStyle: myTheme.appBarTheme.titleTextStyle,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Details for $user',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'More information about $user would go here.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: myTheme.colorScheme.secondary,
    );
  }
}