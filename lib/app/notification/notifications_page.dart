import 'dart:developer';
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/friendship/friendship_bloc.dart';
import 'package:hedeyati/bloc/friendship/frienship_events.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/bloc/notification/notification_bloc.dart';
import 'package:hedeyati/models/model.dart';
import 'package:hedeyati/models/notification.dart' as NotificationModel;
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import '../../bloc/friendship/friendship_states.dart';
import '../../bloc/generic_bloc/generic_crud_events.dart';
import '../../models/friendship.dart';
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
    notificationBloc.initializeStreams();
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
                  setState(() {});
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
                    return _buildNotificationTab(notifications!,_tabController.index);
                  }

                  final friendRequests = notifications
                      .where((notification) => notification.type == NotificationModel.NotificationType.friendRequest)
                      .toList();

                  final otherNotifications = notifications
                      .where((notification) => notification.type == NotificationModel.NotificationType.other)
                      .toList();

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _markNotificationsAsRead(friendRequests);
                    _markNotificationsAsRead(otherNotifications);
                  });

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildNotificationTab(friendRequests, 0),
                      _buildNotificationTab(otherNotifications, 1),
                    ],
                  );
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

  Widget _buildNotificationTab(List<NotificationModel.Notification> notifications, int tabIndex) {
    final title = tabIndex == 0 ? 'Friend Requests' : 'Other Notifications';
    final content = <Widget>[
      Center(child: Text(title, style: myTheme.textTheme.headlineMedium)),
      const SizedBox(height: 16),
    ];

    if (notifications.isEmpty) {
      content.add(Center(
        child: Text(
          tabIndex == 0 ? 'No friend requests yet!' : 'No notifications yet!',
          style: myTheme.textTheme.bodyLarge,
        ),
      ));
    } else {
      content.addAll(notifications.map((notification) => _buildNotificationTile(notification)).toList());
    }

    return buildCard(context, content);
  }

  Widget _buildNotificationTile(NotificationModel.Notification notification) {
    return BlocBuilder<FriendshipBloc, ModelStates>(
      buildWhen: (previous, current) {
        // Rebuild only if the state change relates to the current notification
        return current is FriendshipStatusLoaded &&
            current.notificationID == notification.id;
      },
      builder: (context, state) {
        final isFriendRequest = notification.type == NotificationModel.NotificationType.friendRequest;
        Widget? trailing;

        if (isFriendRequest) {
          if (state is FriendshipStatusLoaded &&
              state.notificationID == notification.id && state.friendshipStatus != 0) {
            // Use the updated status for this specific notification
            final status = state.friendshipStatus;
            trailing = _buildFriendRequestStatus(status);
          } else {
            log('Notification Requester: ${notification.initiatorID} , Reciever: ${notification.receiverID} , Notification ID: ${notification.id}');
            context.read<FriendshipBloc>().add(GetFriendRequestStatus(
              requesterID: notification.initiatorID,
              recieverID: notification.receiverID,
              notificationID: notification.id!,
            ));

            trailing = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.pinkAccent),
                  onPressed: () => _acceptFriendRequest(notification),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: Colors.pinkAccent),
                  onPressed: () => _declineFriendRequest(notification),
                ),
              ],
            );
          }
        }

        return ListTile(
          leading: Icon(
            isFriendRequest ? Icons.person_add : Icons.notifications,
            color: Colors.pinkAccent,
          ),
          title: Text(
            notification.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(notification.body),
          trailing: trailing,
        );
      },
    );
  }



  Widget _buildFriendRequestStatus(int status) {
    final isAccepted = status == 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAccepted ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isAccepted ? Colors.green : Colors.red, width: 1),
      ),
      child: Text(
        isAccepted ? "Accepted" : "Declined",
        style: TextStyle(
          color: isAccepted ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
  void _acceptFriendRequest(NotificationModel.Notification notification) {
    context.read<FriendshipBloc>().add(FriendRequestUpdateStatus(
      requesterID: notification.initiatorID,
      recieverID: notification.receiverID,
      accept: true,
    ));
  }

  void _declineFriendRequest(NotificationModel.Notification notification) {
    context.read<FriendshipBloc>().add(FriendRequestUpdateStatus(
      requesterID: notification.initiatorID,
      recieverID: notification.receiverID,
      accept: false,
    ));
  }
}


