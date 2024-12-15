import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/models/friendship.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';
import '../generic_bloc/generic_crud_bloc.dart';

class FriendshipBloc extends ModelBloc<Friendship> {
  FriendshipBloc(String userID) : super(model: Friendship.dummy()) {
    _initializeStreams(userID: userID);
  }

  late final Stream<List<Friendship>> friendshipStream;

  void _initializeStreams({required String userID}) {
    List<Map<String, QueryArg>> queryArgs = [{'members' : QueryArg(arrayContains: userID)}];

    friendshipStream = friendshipCRUD.getSnapshotsWhere(queryArgs)
        .map((snapshot) => snapshot.docs.map((doc) => doc.data() as Friendship).toList());
  }


  static FriendshipBloc get(context) => BlocProvider.of(context);

}