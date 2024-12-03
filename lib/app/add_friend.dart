import 'package:flutter/material.dart';
import 'package:hedeyati/app/app_theme.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _usernameController = TextEditingController();

  void _addFriend() {
    final String friendName = _usernameController.text.trim();

    if (friendName.isNotEmpty) {
      // Display a confirmation dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$friendName added'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Clear the username field and dismiss the dialog
                  _usernameController.clear();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
            backgroundColor: myTheme.colorScheme.secondary,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 70, 0),
          child: Center(child: Text('Add Friend')),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: const NetworkImage('')),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Enter friend\'s username',
                hintStyle: TextStyle(color: myTheme.hintColor),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: myTheme.primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addFriend,
              child: Text('Add Friend'),
            ),
          ],
        ),
      ),
      backgroundColor: myTheme.colorScheme.secondary,
    );
  }
}
