import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';
import '../../models/event.dart';
import '../generic_bloc/generic_crud_bloc.dart';

class EventBloc extends ModelBloc<Event> {
  EventBloc() : super(model: Event.dummy()) {
    _initializeStreams();
  }

  late final Stream<List<Event>> _myEventsStream;
  late final Stream<List<Event>> _friendsEventsStream;

  void _initializeStreams() {
    _myEventsStream = eventCRUD.getSnapshotsWhere([
      {'firestoreUserID': QueryArg(isEqualTo: FirebaseAuth.instance.currentUser!.uid)},
      {'isDeleted': QueryArg(isEqualTo: false)}
    ]).map((snapshot) => snapshot.docs.map((doc) => doc.data() as Event).toList());

    _friendsEventsStream = eventCRUD.getSnapshotsWhere([
      {'firestoreUserID': QueryArg(isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)},
      {'isDeleted': QueryArg(isEqualTo: false)}
    ]).map((snapshot) => snapshot.docs.map((doc) => doc.data() as Event).toList());
  }

  static EventBloc get(context) => BlocProvider.of(context);
  Stream<List<Event>> get myEventsStream => _myEventsStream;
  Stream<List<Event>> get friendsEventsStream => _friendsEventsStream;

}