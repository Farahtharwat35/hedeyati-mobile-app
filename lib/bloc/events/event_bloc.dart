import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/database/firestore/friendship_crud.dart';
import 'package:hedeyati/helpers/response.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/crud/sqflite_crud_service_class.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';
import '../../models/event.dart';
import '../generic_bloc/generic_crud_bloc.dart';
import '../generic_bloc/generic_states.dart';
import 'event_events.dart';

class EventBloc extends ModelBloc<Event> {
  EventBloc() : super(model: Event.dummy()){
    on<SaveEventLocally>(_saveEventLocally);
  }

  late Stream<List<Event>> _myEventsStream;
  late Stream<List<Event>> _friendsEventsStream;

  Future<void> initializeStreams() async {

    await FriendshipCRUD().getMyFriendsIDs(FirebaseAuth.instance.currentUser!.uid).then((friendsIDs) {
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

  Future<void> _saveEventLocally(SaveEventLocally event, Emitter emit) async {
    log('***********Saving event locally [EVENT EMIITED]***********');
    emit(ModelLoadingState());
    log('***********Saving event locally [EVENT LOADING]***********');
    try {
      await SqliteDatabaseCRUD.batchAlterModel('Event', AlterType.insert, [event.event.toJson()], conflictAlgorithm: ConflictAlgorithm.replace);
      log('***********Saving event locally [EVENT SAVED]***********');
      emit(ModelSuccessState(message: Response(success: true, message: 'Event saved successfully')));
    } catch (e) {
      log('***********Saving event locally [EVENT ERROR]***********');
      emit(ModelErrorState(message: Response(success: false, message: e.toString())));
    }
  }



  static EventBloc get(context) => BlocProvider.of(context);
  Stream<List<Event>> get myEventsStream => _myEventsStream;
  Stream<List<Event>> get friendsEventsStream => _friendsEventsStream;

}