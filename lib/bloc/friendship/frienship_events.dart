
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