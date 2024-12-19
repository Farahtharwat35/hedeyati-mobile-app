import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import 'package:hedeyati/bloc/friendship/frienship_events.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/bloc/user/user_event.dart';
import 'package:hedeyati/helpers/query_arguments.dart';
import 'package:hedeyati/models/user.dart' as User;
import '../../bloc/friendship/friendship_bloc.dart';
import '../../bloc/generic_bloc/generic_states.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_states.dart';
import '../../models/friendship.dart';
import '../../models/user.dart';
import '../reusable_components/build_card.dart';

List<int> numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

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

          List<Widget> friendWidgets = [];

          context.read<FriendshipBloc>().add((GetMyFriendsList(userID: userID , friendships:  friendships)));
          return BlocBuilder<FriendshipBloc, ModelStates>(
            builder: (context, userState) {
              if (userState is ModelLoadedState) {
                for (User.User user in userState.models as List<User.User>) {
                  log("User: ${user.username}");
                  friendWidgets.add(
                    ListTile(
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
                      trailing: (() {
                        int x = generate_random_number();
                        return x > 0
                            ? CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Text(
                            numbers[math.Random().nextInt(numbers.length)]
                                .toString(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                          ),
                        )
                            : null;
                      })(),
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
                    ),
                  );
                }
              }
                return buildCard(context, friendWidgets);
              },
          );
        }
        log("No friendships found.");
        return const Center(child: Text("No friends found."));
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
        title: Center(child: Text(user.username)),
        titleTextStyle: myTheme.appBarTheme.titleTextStyle,
      ),
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
                    'More information about ${user.username} would go here.',
                    style: const TextStyle(color: Colors.white70),
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

  Future<void> loadFriendModel(BuildContext context, String friendID) async {
    Completer<void> completer = Completer<void>();

    StreamSubscription? subscription;
    subscription = context.read<UserBloc>().stream.listen((state) {
      if (state is ModelLoadedState) {
        if (state.models.any((model) => model.id == friendID)) {
          completer.complete();
          subscription?.cancel();
        }
      }
    });

    context.read<UserBloc>().add(LoadModel([{'id': QueryArg(isEqualTo: friendID)}]));

    // Wait for the completer to complete
    await completer.future;
  }

}