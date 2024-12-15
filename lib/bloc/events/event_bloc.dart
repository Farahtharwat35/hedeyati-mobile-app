import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/database/firestore/friendship_crud.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';
import '../../models/event.dart';
import '../generic_bloc/generic_crud_bloc.dart';

class EventBloc extends ModelBloc<Event> {
  EventBloc() : super(model: Event.dummy());

  late Stream<List<Event>> _myEventsStream;
  late Stream<List<Event>> _friendsEventsStream;

  Future<void> initializeStreams() async {

    await FriendshipCRUD().getMyFriendsIDs().then((friendsIDs) {
      if (friendsIDs.isNotEmpty) {
      _friendsEventsStream =  eventCRUD.getSnapshotsWhere([
        {'isDeleted': QueryArg(isEqualTo: false)},
        {'firestoreUserID': QueryArg(whereIn: friendsIDs)}
  ]).map((snapshot) => snapshot.docs.map((doc) => doc.data() as Event).toList());}
      else {
        _friendsEventsStream = Stream.value([]);
      }
    });

    _myEventsStream = eventCRUD.getSnapshotsWhere([
      {'firestoreUserID': QueryArg(isEqualTo: FirebaseAuth.instance.currentUser!.uid)},
      {'isDeleted': QueryArg(isEqualTo: false)}
    ]).map((snapshot) => snapshot.docs.map((doc) => doc.data() as Event).toList());

  }

  static EventBloc get(context) => BlocProvider.of(context);
  Stream<List<Event>> get myEventsStream => _myEventsStream;
  Stream<List<Event>> get friendsEventsStream => _friendsEventsStream;

}