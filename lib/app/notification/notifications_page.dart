import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hedeyati/bloc/notification/notification_bloc.dart';
import 'package:hedeyati/models/notification.dart' as NotificationModel;
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import '../../bloc/generic_bloc/generic_crud_events.dart';
import '../reusable_components/build_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late NotificationBloc notificationBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    notificationBloc = context.read<NotificationBloc>();
    notificationBloc.initializeStreams();  // Initialize the streams when the page is loaded
  }
  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        // Access notifications via the StreamBuilder instead of trying to use .value
        notificationBloc.currentNotifications.listen((notifications) {
          List<NotificationModel.Notification>? selectedTabNotifications;

          if (_tabController.index == 0) {
            // Friend Requests Tab
            selectedTabNotifications = notifications
                .where((notification) =>
            notification.type == NotificationModel.NotificationType.friendRequest && !notification.isRead)
                .toList();
          } else if (_tabController.index == 1) {
            // Other Notifications Tab
            selectedTabNotifications = notifications
                .where((notification) =>
            notification.type == NotificationModel.NotificationType.other && !notification.isRead)
                .toList();
          }

          // Mark unread notifications as read
          if (selectedTabNotifications != null) {
            for (var notification in selectedTabNotifications) {
              notificationBloc.add(UpdateModel(notification.copyWith(isRead: true)));
            }
          }
        });
      });
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.pinkAccent,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.pinkAccent,
              tabs: const [
                Tab(text: "Friend Requests"),
                Tab(text: "Other Notifications"),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<NotificationModel.Notification>>(
              stream: notificationBloc.currentNotifications,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No notifications found!'));
                } else {
                  final notifications = snapshot.data!;
                  final friendRequests = notifications
                      .where((notification) => notification.type == NotificationModel.NotificationType.friendRequest)
                      .toList();
                  final otherNotifications = notifications
                      .where((notification) => notification.type == NotificationModel.NotificationType.other)
                      .toList();
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildNotificationTab(friendRequests, "No friend requests yet!"),
                      _buildNotificationTab(otherNotifications, "No notifications yet!"),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTab(List<NotificationModel.Notification> notifications, String emptyMessage) {
    List<Widget> content = [];
    content.add(Center(
      child: _tabController.index == 0
          ? Text(
        'Friend Requests',
        style: myTheme.textTheme.headlineMedium,
      )
          : Text(
        'Other Notifications',
        style: myTheme.textTheme.headlineMedium,
      ),
    ));
    content.add(const SizedBox(height: 16));

    if (notifications.isEmpty) {
      content.add(Center(
        child: Text(
          emptyMessage,
          style: myTheme.textTheme.bodyLarge,
        ),
      ));
    } else {
      content.addAll(
        notifications.map((notification) => _buildNotificationTile(notification)).toList(),
      );
    }
    return buildCard(context, content);
  }

  Widget _buildNotificationTile(NotificationModel.Notification notification) {
    return ListTile(
      leading: notification.type == NotificationModel.NotificationType.friendRequest
          ? const Icon(Icons.person_add , color: Colors.pinkAccent)
          : const Icon(Icons.notifications , color: Colors.pinkAccent),
      title: Text(
        notification.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(notification.body),
      trailing: Text(
        notification.isRead ? "Read" : "Unread",
        style: TextStyle(color: notification.isRead ? Colors.grey : Colors.pinkAccent),
      ),
    );
  }
}
