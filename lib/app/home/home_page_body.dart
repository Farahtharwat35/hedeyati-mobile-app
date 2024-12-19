import 'dart:developer';
import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import 'package:hedeyati/bloc/friendship/frienship_events.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/helpers/listFiltering.dart';
import 'package:hedeyati/models/user.dart' as User;
import '../../bloc/events/event_bloc.dart';
import '../../bloc/friendship/friendship_bloc.dart';
import '../../bloc/generic_bloc/generic_states.dart';
import '../../models/event.dart';
import '../../models/friendship.dart';
import '../reusable_components/build_card.dart';


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
              if(userState is ModelLoadingState){
                return const Center(child: CircularProgressIndicator());
              }
              if (userState is ModelLoadedState) {
                return AsyncBuilder<List<Event>>(
                  stream: context.read<EventBloc>().friendsEventsStream,
                  builder: (context, events) {
                    List<Widget> friendWidgets = [
                      Center(child: Text('Friends', style: myTheme.textTheme.headlineMedium))
                    ];
                    for (User.User user in userState.models as List<User.User>) {
                      log("Building widget for user: ${user.username}");

                      friendWidgets.add(_buildFriendsTile(context, user , events?? [] , friendships.where((friendship) => friendship.members.contains(user.id)).first));
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

  Widget _buildFriendsTile(BuildContext context, User.User user, List<Event> events, Friendship friendship) {
    List<Event> upcomingEvents = filterList(events ?? [], (event) {
      log("Event FireStoreUserID: ${event.firestoreUserID}");
      return event.createdAt!.isBefore(DateTime.now()) && event.firestoreUserID == user.id;
    });

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
          style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold),
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
            builder: (context) => DetailPage(user: user, friendship: friendship , friendshipBloc: FriendshipBloc(userID: FirebaseAuth.instance.currentUser!.uid)),
          ),
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final User.User user;
  final Friendship friendship;
  final FriendshipBloc friendshipBloc;

  const DetailPage({super.key, required this.user, required this.friendship ,required this.friendshipBloc});

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
      backgroundColor: myTheme.colorScheme.secondary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.pinkAccent, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
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
                    'Details for ${user.username}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Email: ${user.email}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      friendshipBloc.add(UpdateModel(
                        friendship.copyWith(
                          id: friendship.id,
                          friendshipStatusID: 2,
                        ),
                      ));

                      Navigator.pop(context);
                    },
                    child: const Text('Remove Friend'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
