

import 'package:firebase_auth/firebase_auth.dart';
import '../../helpers/query_arguments.dart';
import '../../models/friendship.dart';
import 'crud.dart';

class FriendshipCRUD extends CRUD<Friendship> {
  FriendshipCRUD() : super(model: Friendship.dummy());

  Friendship fromJson(Map<String, dynamic> json) => Friendship.fromJson(json);


  Map<String, dynamic> toJson(Friendship model) => model.toJson();

  Future<List<Friendship>> getMyFriends() async {
    return await getWhere([{'members' : QueryArg(arrayContains: FirebaseAuth.instance.currentUser!.uid)}, {'friendshipStatusID': QueryArg(isEqualTo: FriendshipStatus.accepted)}]);
  }

  Future<List<String>> getMyFriendsIDs() async {
    List<Friendship> friends = await getMyFriends();
    return friends.map((friend) => friend.members.firstWhere((member) => member != FirebaseAuth.instance.currentUser!.uid)).toList();
  }

}