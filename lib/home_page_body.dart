import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hedeyati/app_theme.dart';


List<String> users = ["John", "Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Helen", "Ivy" , "Jack", "Kate", "Liam", "Mia", "Noah" , "Olivia", "Peter", "Quinn", "Rose", "Sam", "Tina", "Uma", "Victor", "Wendy", "Xander", "Yara", "Zane"];
List<int> numbers = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];

int generate_random_number () {
  return numbers[Random().nextInt(numbers.length)];
}

class FriendsListWidget extends StatefulWidget {
  const FriendsListWidget({super.key});

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsListWidget> {
  Future<List<String>> future = Future.value(users); // Mocking

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(user: users[index]),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    trailing: (() {
                      int x = generate_random_number();
                      return x > 0 ?
                      CircleAvatar(
                        radius: 12,
                        child: Text(numbers[Random().nextInt(numbers.length)].toString(), style: const TextStyle(fontSize: 12)),
                      ) : null;
                    })(),
                    title: Text(snapshot.data![index]),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}


class DetailPage extends StatelessWidget {
  final String user;

  const DetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(padding: const EdgeInsets.fromLTRB(15,0,70,0),
          child: Center(child: Text(user)),
        ),
        titleTextStyle: myTheme.appBarTheme.titleTextStyle,
      ),
      body: Center(
        child: Text('Details for $user'),
      ),
      backgroundColor: myTheme.colorScheme.secondary,
    );
  }
}
