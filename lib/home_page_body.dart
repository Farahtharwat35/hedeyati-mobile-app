import 'package:flutter/material.dart';


List<String> users = ["John", "Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Helen", "Ivy" , "Jack", "Kate", "Liam", "Mia", "Noah" , "Olivia", "Peter", "Quinn", "Rose", "Sam", "Tina", "Uma", "Victor", "Wendy", "Xander", "Yara", "Zane"];

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
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
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
        title: Text(user),
      ),
      body: Center(
        child: Text('Details for $user'),
      ),
    );
  }
}
