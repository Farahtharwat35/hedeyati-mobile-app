

import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';

import '../../models/event.dart' ;

class SaveEventLocally extends GenericCRUDEvents {
  final Event event;

  SaveEventLocally(this.event);

  @override
  List<Object> get props => [event];
}