import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/database/firestore/friendship_crud.dart';
import 'package:hedeyati/models/friendship.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';
import '../../helpers/response.dart';
import '../generic_bloc/generic_crud_bloc.dart';
import 'frienship_events.dart';

class FriendshipBloc extends ModelBloc<Friendship> {
  FriendshipBloc(String userID) : super(model: Friendship.dummy()) {
    _initializeStreams(userID: userID);
    on<AddFriend>(addFriend);
    on<GetMyFriends>(getFriendships);
  }

  late final Stream<List<Friendship>> friendshipStream;

  void _initializeStreams({required String userID}) {
    List<Map<String, QueryArg>> queryArgs = [{'members' : QueryArg(arrayContains: userID)}];

    friendshipStream = FriendshipCRUD().getSnapshotsWhere(queryArgs)
        .map((snapshot) => snapshot.docs.map((doc) => doc.data() as Friendship).toList());
  }

  Future<void> addFriend(AddFriend addFriend , Emitter emit) async{
    emit(ModelLoadingState());
    //  Checking if you are not adding yourself as a friend
    if (addFriend.friendship.recieverID == FirebaseAuth.instance.currentUser!.uid) {
      log('***********You can not add yourself as a friend***********');
      emit(ModelErrorState(message: Response(success: false, message:'You can not add yourself as a friend')));
    }
    List<Friendship> friends = await FriendshipCRUD().getMyFriends();
    if (friends.isEmpty) {
    try {
      FriendshipCRUD().add(addFriend.friendship);
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

  Future<void> getFriendships(GetMyFriends myFriends , Emitter emit) async{
    List<Friendship> friendships = await FriendshipCRUD().getMyFriends();
    if (friendships.isEmpty) {
      emit(ModelEmptyState());
      return;
    }
  }

  static FriendshipBloc get(context) => BlocProvider.of(context);

}