

import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';

import '../../models/event.dart' ;

class SaveEventLocally extends GenericCRUDEvents {
  final Event event;

  SaveEventLocally(this.event);

  @override
  List<Object> get props => [event];
}

class UpdateEventLocally extends GenericCRUDEvents {
  final Event event;

  UpdateEventLocally(this.event);

  @override
  List<Object> get props => [event];
}

class DeleteEventLocally extends GenericCRUDEvents {
  final String eventID;

  DeleteEventLocally(this.eventID);

  @override
  List<Object> get props => [eventID];
}

class GetEventsLocally extends GenericCRUDEvents {
  @override
  List<Object> get props => [];
}

class GetEventLocally extends GenericCRUDEvents {
  final String eventID;

  GetEventLocally(this.eventID);

  @override
  List<Object> get props => [eventID];
}