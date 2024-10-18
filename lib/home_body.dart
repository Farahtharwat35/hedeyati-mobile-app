import 'package:flutter/material.dart';

List<String> users = List<String>.generate(10000, (i) => 'Contact $i');

class FriendsListWidget extends StatefulWidget {
  const FriendsListWidget({super.key});

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsListWidget> {
  Future<List<String>> future = Future.value(users); //moking

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

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      prototypeItem: ListTile(
        title: Text(users.first),
      ),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index]),
        );
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
// @override
// void initState(repository) {
//   future = repository.fetchFriendsList();
//   super.initState();
// }