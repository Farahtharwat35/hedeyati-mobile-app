import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/database/firestore/friendship_crud.dart';
import 'package:hedeyati/models/friendship.dart';
import '../../helpers/query_arguments.dart';
import '../../helpers/response.dart';
import '../generic_bloc/generic_crud_bloc.dart';
import 'friendship_states.dart';
import 'frienship_events.dart';
import '../../database/firestore/crud.dart';
import '../../models/user.dart' as User;

class FriendshipBloc extends ModelBloc<Friendship> {
  FriendshipBloc({required this.userID}) : super(model: Friendship.dummy()) {
    on<AddFriend>(addFriend);
    // on<GetMyFriendships>(getFriendships);
    on<GetMyFriendsList>(getMyFriendsModels);
    on<FriendRequestUpdateStatus>(updateFriendRequestStatus);
    on<GetFriendRequestStatus>(getFriendRequestStatus);
  }
  late final String userID;
  late final Stream<List<Friendship>> _friendshipStream;
  final FriendshipCRUD friendshipCRUD = FriendshipCRUD();

  void initializeStreams() {
    List<Map<String, QueryArg>> queryArgs = [{'members' : QueryArg(arrayContains: userID)} , {'friendshipStatusID': QueryArg(isEqualTo: FriendshipStatus.accepted.index)}];

    _friendshipStream = friendshipCRUD.getSnapshotsWhere(queryArgs)
        .map((snapshot) => snapshot.docs.map((doc) => doc.data() as Friendship).toList());
  }

  Future<void> addFriend(AddFriend addFriend , Emitter emit) async{
    emit(ModelLoadingState());
    //  Checking if you are not adding yourself as a friend
    if (addFriend.friendship.recieverID == addFriend.friendship.requesterID) {
      log('***********You can not add yourself as a friend***********');
      emit(ModelErrorState(message: Response(success: false, message:'You can not add yourself as a friend')));
      return;
    }
    List<Friendship> friends = await friendshipCRUD.getMyFriendships(addFriend.friendship.requesterID);
    if (friends.isEmpty) {
    try {
      List<String> pendingFriendRequests = await friendshipCRUD.getMyPendingFriendsIDs(addFriend.friendship.requesterID);
      if(pendingFriendRequests.contains(addFriend.friendship.recieverID)){
        log('***********You have already sent a friend request to this user***********');
        emit(ModelErrorState(message: Response(success: false, message: 'You have already sent a friend request to this user')));
        return;
      }
      friendshipCRUD.add(model:addFriend.friendship);
      log('***********Friendship added successfully***********');
      emit(ModelAddedState(addFriend.friendship));
    } catch (e) {
      log('***********Failed to add model: $e***********');
      emit(ModelErrorState(message: Response(success: false, message: 'Failed to add model: $e')));
    }
  }else {
      log('***********You are already friends***********');
      emit(ModelErrorState(message: Response(success: false, message: 'You are already friends')));
    }
  }

  Future<void> getMyFriendsModels(GetMyFriendsList myFriendships , Emitter emit) async{
    List<String> friendsIDs = myFriendships.friendships.map((friendship) => friendship.requesterID == userID ? friendship.recieverID : friendship.requesterID).toList();
    // I want to get the users by IDs
    List<Map<String, QueryArg>> queryArgs = [{'id': QueryArg(whereIn: friendsIDs)}];
    List<User.User> friends = await userCRUD.getWhere(queryArgs);
    if (friends.isEmpty) {
      emit(ModelEmptyState());
      return;
    }
    emit(ModelLoadedState(friends));
  }

  // Future<void> getFriendships(GetMyFriends myFriends , Emitter emit) async{
  //   List<Friendship> friendships = await FriendshipCRUD().getMyFriendships(myFriends.userID);
  //   if (friendships.isEmpty) {
  //     emit(ModelEmptyState());
  //     return;
  //   }
  // }

  Future<void> updateFriendRequestStatus(FriendRequestUpdateStatus friendRequest , Emitter emit) async{
    log('***********Friend Request Update Status Event Triggered***********');
    late Friendship friendship;
    try {
      List<Friendship> friendships = await friendshipCRUD.getWhere([{'requesterID': QueryArg(isEqualTo: friendRequest.requesterID), 'recieverID': QueryArg(isEqualTo: friendRequest.recieverID)}]);
      if(friendships.isEmpty) {
          log('***********No friend request found***********');
          emit(ModelEmptyState());
          return;
        };
      if (friendRequest.accept) {
        log('***********Updating Friendship status to be accepted ... ***********');
        friendship = friendships.first.copyWith(id:friendships.first.id,friendshipStatusID: FriendshipStatus.accepted.index);
        log('-----------------Friendship After Update: $friendship-----------------');
      } else {
        log('***********Updating Friendship status to be rejected ... ***********');
        friendship =  friendships.first.copyWith(
          id: friendships.first.id,
          friendshipStatusID: FriendshipStatus.rejected.index,
          isDeleted: true,
          deletedAt: DateTime.now()
        );
      }
      try{
        await friendshipCRUD.update(friendship);
        log('***********Friendship status updated successfully***********');
        emit(ModelUpdatedState(friendship));
      } catch (e) {
        log('***********Failed to update model: $e***********');
        emit(ModelErrorState(message: Response(success: false, message: 'Failed to update model: $e')));
      }
    } catch (e) {
      emit(ModelErrorState(message: Response(success: false, message: 'Failed to update model: $e')));
    }
  }

  Future<void> getFriendRequestStatus(GetFriendRequestStatus friendRequest , Emitter emit) async{
    log('***********Friend Request Status Event Triggered***********');
    try {
      List<Friendship> friendships = await friendshipCRUD.getWhere([{'requesterID': QueryArg(isEqualTo: friendRequest.requesterID), 'recieverID': QueryArg(isEqualTo: friendRequest.recieverID)}]);
      if(friendships.isEmpty) {
        log('***********No friend request found***********');
        emit(ModelEmptyState());
        return;
      };
      log('***********Friend Request Found***********');
      log('***********Friendship Status: ${friendships.first.friendshipStatusID} for notification ${friendRequest.notificationID} ***********');
      emit(FriendshipStatusLoaded(friendships.first.friendshipStatusID!, friendRequest.notificationID));
    } catch (e) {
      emit(ModelErrorState(message: Response(success: false, message: 'Failed to get model: $e')));
    }
  }

  Stream<List<Friendship>> get myFriendsStream => _friendshipStream;

  static FriendshipBloc get(context) => BlocProvider.of(context);

}