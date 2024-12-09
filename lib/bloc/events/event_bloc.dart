import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/events/event_bloc_events.dart';
import 'package:hedeyati/bloc/events/event_bloc_states.dart';
import 'package:hedeyati/models/event.dart';
import '../../helpers/query_arguments.dart';
import '../../models/model.dart';
import 'package:hedeyati/database/firestore/crud.dart';

class EventBloc extends Bloc<Event_E, EventState> {
  EventBloc() : super(EventInitial()) {
    on<LoadFriendsEvents>(getMyFriendsEvents);
    on<LoadMyEvents>(getMyEvents);
  }

  Future<Stream<QuerySnapshot<Model>>> getMyEvents(LoadMyEvents event,Emitter<EventState> emit) async {
    emit(EventsLoading());
    return eventCRUD.getSnapshotsWhere([
      {'firestoreUserID': QueryArg(isEqualTo: FirebaseAuth.instance.currentUser!.uid)}
    ]);
  }

  Future<Stream<QuerySnapshot<Model>>> getMyFriendsEvents(LoadFriendsEvents event,Emitter<EventState> emit) async {
    emit(EventsLoading());
    return eventCRUD.getSnapshotsWhere([
      {'firestoreUserID': QueryArg(isNotEqualTo: Event.instance.doc(FirebaseAuth.instance.currentUser!.uid))}
    ]);
  }
}