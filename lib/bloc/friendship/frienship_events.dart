
import 'package:flutter/cupertino.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';

import '../../models/friendship.dart';

class AddFriend extends GenericCRUDEvents {
  final Friendship friendship;

  AddFriend(this.friendship);
}

class GetMyFriends extends GenericCRUDEvents {
  final String userID;

  GetMyFriends(this.userID);
}

class FriendRequestUpdateStatus extends GenericCRUDEvents {
  final String requesterID;
  final String recieverID;
  final bool accept;

  FriendRequestUpdateStatus({required this.requesterID, required this.recieverID, required this.accept});

}

class GetFriendRequestStatus extends GenericCRUDEvents {
  final String requesterID;
  final String recieverID;
  final String notificationID;

  GetFriendRequestStatus({required this.requesterID, required this.recieverID, required this.notificationID});
}