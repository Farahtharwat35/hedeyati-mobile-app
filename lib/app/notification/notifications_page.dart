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
    required this.friendName,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Notification> friendRequests = [];
  List<Notification> otherNotifications = [];

  void addNotification(String title, String description, String friendAvatar, String friendName,
      {bool isFriendRequest = false}) {
    final newNotification = Notification(
      title: title,
      description: friendName + description,
      date: DateTime.now(),
      friendName: friendName,
      friendAvatar: friendAvatar,
    );

    setState(() {
      if (isFriendRequest) {
        friendRequests.add(newNotification);
      } else {
        otherNotifications.add(newNotification);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Create 15 sample notifications (10 other notifications, 5 friend requests)
    for (int i = 1; i <= 10; i++) {
      Future.delayed(Duration(seconds: i), () {
        addNotification(
          "Gift Selected",
          " has selected a gift from your wishlist!",
          "https://static.vecteezy.com/system/resources/previews/029/784/435/non_2x/two-beautiful-charming-young-women-take-a-selfie-on-the-seashore-lgbtq-plus-couple-or-best-friends-generative-ai-photo.jpg",
          "Friend $i",
        );
      });
    }

    for (int i = 1; i <= 5; i++) {
      Future.delayed(Duration(seconds: i * 2), () {
        addNotification(
          "Friend Request",
          " has sent you a friend request!",
          "https://static.vecteezy.com/system/resources/previews/029/784/435/non_2x/two-beautiful-charming-young-women-take-a-selfie-on-the-seashore-lgbtq-plus-couple-or-best-friends-generative-ai-photo.jpg",
          "Friend Request $i",
          isFriendRequest: true,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.pinkAccent,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.pinkAccent,
          tabs: const [
            Tab(text: "Friend Requests"),
            Tab(text: "Other Notifications"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Friend Requests Tab
              friendRequests.isEmpty
                  ? Center(
                child: Text("No friend requests yet!",
                    style: myTheme.textTheme.headlineMedium),
              )
                  : ListView.builder(
                itemCount: friendRequests.length,
                itemBuilder: (context, index) {
                  final notification = friendRequests[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                      NetworkImage(notification.friendAvatar),
                      child: notification.friendAvatar.isEmpty
                          ? Text(notification.title[0])
                          : null,
                    ),
                    title: Text(notification.title),
                    subtitle: Text(notification.description),
                    trailing: Text(
                      "${notification.date.hour}:${notification.date.minute}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                },
              ),

              // Other Notifications Tab
              otherNotifications.isEmpty
                  ? Center(
                child: Text("No notifications yet!",
                    style: myTheme.textTheme.headlineMedium),
              )
                  : ListView.builder(
                itemCount: otherNotifications.length,
                itemBuilder: (context, index) {
                  final notification = otherNotifications[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                      NetworkImage(notification.friendAvatar),
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
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
