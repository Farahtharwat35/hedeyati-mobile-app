import 'package:flutter/material.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';

// Notification model
class Notification {
  final String title;
  final String description;
  final DateTime date;
  final String friendName;
  final String friendAvatar;

  Notification({
    required this.title,
    required this.description,
    required this.date,
    required this.friendAvatar,
    required this.friendName
  });
}

// NotificationPage widget
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notification> notifications = [];

  void addNotification(String title, String description, String friendAvatar , String friendName) {
    final newNotification = Notification(
      title: title,
      description: friendName + description,
      date: DateTime.now(),
      friendName: friendName,
      friendAvatar: friendAvatar,
    );

    setState(() {
      notifications.add(newNotification);
    });
  }

  @override
  void initState() {
    super.initState();

    // Create 15 sample notifications
    for (int i = 1; i <= 15; i++) {
      Future.delayed(const Duration(seconds: 2), () {
        addNotification(
          "Gift Selected",
          " has selected a gift from your wishlist!",
          "https://static.vecteezy.com/system/resources/previews/029/784/435/non_2x/two-beautiful-charming-young-women-take-a-selfie-on-the-seashore-lgbtq-plus-couple-or-best-friends-generative-ai-photo.jpg",
          "Friend $i",
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(15,0,70,0),
          child: const Center(child: Text("Activity")),
        ),
        titleTextStyle: myTheme.textTheme.headlineMedium,
        backgroundColor: Colors.white70,
      ),
      body: notifications.isEmpty
          ? Center(child: Text("No notifications yet!", style: myTheme.textTheme.headlineMedium))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(notification.friendAvatar),
              child: notification.friendAvatar.isEmpty
                  ? Text(notification.title[0])
                  : null,
            ),
            title: Text(notification.title),
            subtitle: Text(notification.description),
            trailing: Text(
              "${notification.date.hour}:${notification.date.minute}",
              style: const TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
