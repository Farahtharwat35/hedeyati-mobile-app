

import 'dart:developer';
import '../../helpers/query_arguments.dart';
import '../../models/friendship.dart';
import '../../shared/friendship_status_enum.dart';
import 'crud.dart';

class FriendshipCRUD extends CRUD<Friendship> {
  FriendshipCRUD() : super(model: Friendship.dummy());

  Friendship fromJson(Map<String, dynamic> json) => Friendship.fromJson(json);


  Map<String, dynamic> toJson(Friendship model) => model.toJson();

  Future<List<Friendship>> getMyFriendships(String userID) async {
    return await getWhere([{'members' : QueryArg(arrayContains: userID)}, {'friendshipStatusID': QueryArg(isEqualTo: FriendshipStatus.accepted.index)}]);
  }

  Future<List<String>> getMyFriendsIDs(String userID) async {
    List<Friendship> friends = await getMyFriendships(userID);
    return friends.map((friend) => friend.members.firstWhere((member) => member != userID)).toList();
  }

  Future<List<String>> getMyPendingFriendsIDs(String userID) async {
    log('***********Getting pending friends***********');
    List<Friendship> pendingRequests = await getWhere([{'members' : QueryArg(arrayContains: userID)}, {'friendshipStatusID': QueryArg(isEqualTo: FriendshipStatus.pending.index)}]);
    log('***********Pending friends: $pendingRequests***********');
    return pendingRequests.map((friend) => friend.members.firstWhere((member) => member != userID)).toList();
  }


}