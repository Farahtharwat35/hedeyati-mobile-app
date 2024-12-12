import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';

List<String> users = [
  "John", "Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace",
  "Helen", "Ivy", "Jack", "Kate", "Liam", "Mia", "Noah", "Olivia", "Peter",
  "Quinn", "Rose", "Sam", "Tina", "Uma", "Victor", "Wendy", "Xander", "Yara", "Zane"
];
List<int> numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

int generate_random_number() {
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16), // Rounded corners for the container
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Rounded corners for the card
                    ),
                    child: Column(
                      children: List.generate(snapshot.data!.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(user: users[index]),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.pinkAccent,
                                child: Text(
                                  snapshot.data![index][0], // First letter of the name
                                  style: TextStyle(
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
                                    numbers[Random().nextInt(numbers.length)].toString(),
                                    style: const TextStyle(fontSize: 12, color: Colors.black),
                                  ),
                                )
                                    : null;
                              })(),
                              title: Text(
                                snapshot.data![index],
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
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
        }
        return const Center(child: CircularProgressIndicator());
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
        title: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 70, 0),
          child: Center(child: Text(user)),
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
