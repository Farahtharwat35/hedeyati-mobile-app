
import 'dart:developer';
import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import 'package:hedeyati/app/reusable_components/delete_dialog.dart';
import 'package:hedeyati/bloc/friendship/frienship_events.dart';
import 'package:hedeyati/helpers/listFiltering.dart';
import 'package:hedeyati/models/user.dart' as User;
import 'package:intl/intl.dart';
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
      return DateTime.parse(event.createdAt!).isBefore(DateTime.now()) && event.firestoreUserID == user.id;
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
        'Tap to view friend details',
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
          padding: const EdgeInsets.all(24.0), // Increase the outer padding
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // Set width to 90% of the screen
            height: MediaQuery.of(context).size.height * 0.4, // Set height to 60% of the screen
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.pinkAccent, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24), // Slightly larger border radius
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12, // Increased blur for a softer shadow
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32), // Adjust inner padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                children: [
                  Text(
                    'Details for ${user.username}',
                    style: const TextStyle(
                      fontSize: 26, // Larger font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24), // Increased spacing
                  Text(
                    'Email: ${user.email}',
                    style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold), // Larger subtitle font
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16), // More spacing
                  Text(
                    'Friends Since: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(friendship.updatedAt!))}',
                    style: const TextStyle(color: Colors.white70, fontSize: 18 , fontWeight: FontWeight.bold), // Larger subtitle font
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32), // More spacing before the button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48), // Larger button
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      return confirmDelete(context, friendshipBloc, friendship, Text("Are you sure you want to remove ${user.username} from your friends list?"));
                    },
                    child: const Text('Remove Friend', style: TextStyle(fontSize: 18 , color: Colors.pinkAccent)), // Larger button text
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
