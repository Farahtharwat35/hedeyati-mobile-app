import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/events/event_bloc_events.dart';
import 'package:hedeyati/bloc/events/event_bloc_states.dart';
import '../../helpers/query_arguments.dart';
import '../../models/event.dart';
import '../../models/model.dart';
import 'package:hedeyati/database/firestore/crud.dart';

class EventBloc extends Bloc<Event_E, EventState> {
  EventBloc() : super(EventInitial()) {
    on<LoadFriendsEvents>(_onLoadFriendsEvents);
    on<LoadMyEvents>(_onLoadMyEvents);
    _initializeStreams();
  }

  late final Stream<List<Event>> myEventsStream;
  late final Stream<List<Event>> friendsEventsStream;

  // Initialize streams here, ensuring they are ready before being used.
  void _initializeStreams() {
    myEventsStream = eventCRUD.getSnapshotsWhere([
      {'firestoreUserID': QueryArg(isEqualTo: FirebaseAuth.instance.currentUser!.uid)},
    ]).map((snapshot) => snapshot.docs.map((doc) => doc.data() as Event).toList());

    friendsEventsStream = eventCRUD.getSnapshotsWhere([
      {'firestoreUserID': QueryArg(isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)},
    ]).map((snapshot) => snapshot.docs.map((doc) => doc.data() as Event).toList());
  }

  Future<void> _onLoadMyEvents(LoadMyEvents event, Emitter<EventState> emit) async {
    emit(EventsLoading());
    try {
      if (myEventsStream == null) {
        _initializeStreams();
      }
      emit(EventStreamLoaded(myEventsStream));
    } catch (e) {
      emit(EventsError(message: 'Failed to load My Events: $e'));
    }
  }

  Future<void> _onLoadFriendsEvents(LoadFriendsEvents event, Emitter<EventState> emit) async {
    emit(EventsLoading());
    try {
      if (friendsEventsStream == null) {
        _initializeStreams();
      }
      emit(EventStreamLoaded(friendsEventsStream));
    } catch (e) {
      emit(EventsError(message: 'Failed to load Friends Events: $e'));
    }
  }
}
