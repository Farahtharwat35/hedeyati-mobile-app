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
import 'event_states.dart';

class EventBloc extends ModelBloc<Event> {
  EventBloc() : super(model: Event.dummy()){
    on<SaveEventLocally>(_saveEventLocally);
    on<DeleteEventLocally>(deleteEventLocally);
    on<UpdateEventLocally>(updateEventLocally);
    on<GetEventLocally>(getEventLocally);
    on<GetEventsLocally>(getAllLocalEvents);
  }

  Stream<List<Event>>? _myEventsStream;
  Stream<List<Event>>? _friendsEventsStream;

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
      log('eventID: ${event.eventID}');
      await SqliteDatabaseCRUD.batchAlterModel('Event', AlterType.update, [{'isDeleted': 1}],where: 'id = ?', whereArgs: [event.eventID] , conflictAlgorithm: ConflictAlgorithm.replace);
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
      await SqliteDatabaseCRUD.batchAlterModel('Event', AlterType.update, [event.event.toJson()], where: 'id = ?', whereArgs: [event.event.id]);
      log('***********Updating event locally [EVENT UPDATED]***********');
      emit(ModelUpdatedState(event.event));
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
      List<Map<String, Object?>> result = await SqliteDatabaseCRUD.getWhere('Event', where: 'id = ? AND isDeleted = 0', whereArgs: [event.eventID]);
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
      List<Map<String, Object?>> events = await SqliteDatabaseCRUD.getWhere('Event' , where: 'isDeleted = 0');
      log('# Events From Local DB: ${events.length}');
      events = dbResultTypesConverter(events , [{'isDeleted': 'bool'}]);
      log('***********Getting all local events [EVENT LOADED]***********');
      events.isNotEmpty ? emit(LoadedLocalEvents(events.map((e) => Event.fromJson(e)).toList())) : emit(ModelEmptyState());
    } catch (e) {
      log('***********Getting all local events [EVENT ERROR]***********');
      emit(ModelErrorState(message: Response(success: false, message: e.toString())));
    }
  }

  static EventBloc get(context) => BlocProvider.of(context);
  Stream<List<Event>> get myEventsStream => _myEventsStream?? Stream.value([]);
  Stream<List<Event>> get friendsEventsStream => _friendsEventsStream?? Stream.value([]);

}