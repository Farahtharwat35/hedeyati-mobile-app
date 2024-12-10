import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/events/event_bloc_events.dart';
import 'package:hedeyati/bloc/events/event_bloc_states.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';
import '../../models/event.dart';
import '../generic_crud_bloc.dart';
import '../generic_states.dart';

class EventBloc extends ModelBloc<Event> {
  EventBloc() : super(model: Event.dummy()) {
    _initializeStreams();
  }

  late final Stream<List<Event>> myEventsStream;
  late final Stream<List<Event>> friendsEventsStream;

  void _initializeStreams() {
    myEventsStream = eventCRUD.getSnapshotsWhere([
      {'firestoreUserID': QueryArg(isEqualTo: FirebaseAuth.instance.currentUser!.uid)},
    ]).map((snapshot) => snapshot.docs.map((doc) => doc.data() as Event).toList());

    friendsEventsStream = eventCRUD.getSnapshotsWhere([
      {'firestoreUserID': QueryArg(isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)},
    ]).map((snapshot) => snapshot.docs.map((doc) => doc.data() as Event).toList());
  }

}