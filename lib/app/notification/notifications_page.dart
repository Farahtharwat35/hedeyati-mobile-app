import 'dart:developer';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/friendship/friendship_bloc.dart';
import 'package:hedeyati/bloc/friendship/frienship_events.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
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
  late bool? isFriendRequestAccepted = null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    notificationBloc = context.read<NotificationBloc>();
    notificationBloc.initializeStreams();  // Initialize the streams when the page is loaded
  }

  void _onTabChanged() {
    if(_tabController.indexIsChanging) {
      setState(() {});
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
            child: BlocListener<FriendshipBloc, ModelStates>(
              listener: (context, state) {
                if (state is ModelUpdatedState) {
                  setState(() {

                  });
                }
              },
              child: AsyncBuilder<List<NotificationModel.Notification>>(
                stream: notificationBloc.currentNotifications,
                waiting: (context) => const Center(child: CircularProgressIndicator()),
                error: (context, error, stackTrace) => buildCard(context, [
                  Text('Error: $error', style: myTheme.textTheme.bodyLarge),
                ]),
                builder: (context, notifications) {
                  if (notifications == null || notifications.isEmpty) {
                    if (_tabController.index == 0) {
                      return buildCard(context, [
                        Center(child: Text('Friend Requests', style: myTheme.textTheme.headlineMedium)),
                        const SizedBox(height: 16),
                        Center(child: Text('No friend requests yet!', style: myTheme.textTheme.bodyLarge)),
                      ]);
                    } else {
                      return buildCard(context, [
                        Center(child: Text('Other Notifications', style: myTheme.textTheme.headlineMedium)),
                        const SizedBox(height: 16),
                        Center(child: Text('No notifications yet!', style: myTheme.textTheme.bodyLarge)),
                      ]);
                    }
                  } else {
                    // Separate the friend requests and other notifications
                    final friendRequests = notifications
                        .where((notification) => notification.type == NotificationModel.NotificationType.friendRequest)
                        .toList();

                    final otherNotifications = notifications
                        .where((notification) => notification.type == NotificationModel.NotificationType.other)
                        .toList();

                    // Only update unread notifications ONCE outside of the builder
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _markNotificationsAsRead(friendRequests);
                      _markNotificationsAsRead(otherNotifications);
                    });

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
          ),
        ],
      ),
    );
  }

  void _markNotificationsAsRead(List<NotificationModel.Notification> notifications) {
    for (var notification in notifications) {
      if (!notification.isRead) {
        context.read<NotificationBloc>().add(UpdateModel(notification.copyWith(isRead: true)));
      }
    }
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
          ? const Icon(Icons.person_add, color: Colors.pinkAccent)
          : const Icon(Icons.notifications, color: Colors.pinkAccent),
      title: Text(
        notification.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(notification.body),
      trailing: notification.type == NotificationModel.NotificationType.friendRequest
          ? (isFriendRequestAccepted != null
          ? (isFriendRequestAccepted == true
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green, width: 1),
        ),
        child: const Text(
          "Accepted",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      )
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2), // Light red background
          borderRadius: BorderRadius.circular(12), // Rounded corners
          border: Border.all(color: Colors.red, width: 1), // Red border
        ),
        child: const Text(
          "Declined",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ))
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Accept Button
          IconButton(
            icon: const Icon(Icons.check, color: Colors.pinkAccent),
            onPressed: () {
              _acceptFriendRequest(notification);
            },
          ),
          // Decline Button
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.red),
            onPressed: () {
              _declineFriendRequest(notification);
            },
          ),
        ],
      ))
          : null,
    );
  }


  void _acceptFriendRequest(NotificationModel.Notification notification) {
    context.read<FriendshipBloc>().add(FriendRequestUpdateStatus(
        requesterID: notification.initiatorID,
        recieverID: notification.receiverID,
        accept: true));
    setState(() {
      isFriendRequestAccepted = true;
    });
  }

  void _declineFriendRequest(NotificationModel.Notification notification) {
    context.read<FriendshipBloc>().add(FriendRequestUpdateStatus(
        requesterID: notification.initiatorID,
        recieverID: notification.receiverID,
        accept: false));
    setState(() {
      isFriendRequestAccepted = false;
    });
    }
  }


