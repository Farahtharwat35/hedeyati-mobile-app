

import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';

class FriendshipStatusLoaded extends ModelStates {
  final int friendshipStatus;
  final String notificationID;

  const FriendshipStatusLoaded(this.friendshipStatus , this.notificationID);

  @override
  List<Object> get props => [friendshipStatus , notificationID];
}
