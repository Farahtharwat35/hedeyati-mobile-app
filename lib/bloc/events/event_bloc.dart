import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/database/firestore/friendship_crud.dart';
import 'package:hedeyati/helpers/response.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/crud/sqflite_crud_service_class.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/dataMapper.dart';
import '../../helpers/query_arguments.dart';
import '../../models/event.dart';
import '../generic_bloc/generic_crud_bloc.dart';
import '../generic_bloc/generic_states.dart';
import 'event_events.dart';

class EventBloc extends ModelBloc<Event> {
  EventBloc() : super(model: Event.dummy()){
    on<SaveEventLocally>(_saveEventLocally);
    on<DeleteEventLocally>(deleteEventLocally);
    on<UpdateEventLocally>(updateEventLocally);
    on<GetEventLocally>(getEventLocally);
    on<GetEventsLocally>(getAllLocalEvents);
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

  Future<void> deleteEventLocally(DeleteEventLocally event, Emitter emit) async {
    log('***********Deleting event locally [EVENT EMIITED]***********');
    emit(ModelLoadingState());
    log('***********Deleting event locally [EVENT LOADING]***********');
    try {
      await SqliteDatabaseCRUD.alterModel('Event', AlterType.update, {'isDeleted': true}, where: 'id = ?', whereArgs: [event.eventID]);
      log('***********Deleting event locally [EVENT DELETED]***********');
      emit(ModelSuccessState(message: Response(success: true, message: 'Event deleted successfully')));
    } catch (e) {
      log('***********Deleting event locally [EVENT ERROR]***********');
      emit(ModelErrorState(message: Response(success: false, message: e.toString())));
    }
  }

  Future<void> updateEventLocally(UpdateEventLocally event, Emitter emit) async {
    log('***********Updating event locally [EVENT EMIITED]***********');
    emit(ModelLoadingState());
    log('***********Updating event locally [EVENT LOADING]***********');
    try {
      await SqliteDatabaseCRUD.alterModel('Event', AlterType.update, event.event.toJson(), where: 'id = ?', whereArgs: [event.event.id]);
      log('***********Updating event locally [EVENT UPDATED]***********');
      emit(ModelSuccessState(message: Response(success: true, message: 'Event updated successfully')));
    } catch (e) {
      log('***********Updating event locally [EVENT ERROR]***********');
      emit(ModelErrorState(message: Response(success: false, message: e.toString())));
    }
  }

  Future<void> getEventLocally(GetEventLocally event, Emitter emit) async {
    log('***********Getting event locally [EVENT EMIITED]***********');
    emit(ModelLoadingState());
    log('***********Getting event locally [EVENT LOADING]***********');
    try {
      List<Map<String, Object?>> result = await SqliteDatabaseCRUD.getWhere('Event', where: 'id = ?', whereArgs: [event.eventID]);
      result = dbResultTypesConverter(result , [{'isDeleted': 'bool'}]);
      log('***********Getting event locally [EVENT LOADED]***********');
      emit(ModelLoadedState([Event.fromJson(result.first)]));
    } catch (e) {
      log('***********Getting event locally [EVENT ERROR]***********');
      emit(ModelErrorState(message: Response(success: false, message: e.toString())));
    }
  }

  Future<void> getAllLocalEvents(GetEventsLocally event ,Emitter emit) async {
    log('***********Getting all local events [EVENT EMIITED]***********');
    emit(ModelLoadingState());
    log('***********Getting all local events [EVENT LOADING]***********');
    try {
      List<Map<String, Object?>> events = await SqliteDatabaseCRUD.getWhere('Event');
      events = dbResultTypesConverter(events , [{'isDeleted': 'bool'}]);
      log('***********Getting all local events [EVENT LOADED]***********');
      emit(ModelLoadedState(events.map((e) => Event.fromJson(e)).toList()));
    } catch (e) {
      log('***********Getting all local events [EVENT ERROR]***********');
      emit(ModelErrorState(message: Response(success: false, message: e.toString())));
    }
  }

  static EventBloc get(context) => BlocProvider.of(context);
  Stream<List<Event>> get myEventsStream => _myEventsStream;
  Stream<List<Event>> get friendsEventsStream => _friendsEventsStream;

}