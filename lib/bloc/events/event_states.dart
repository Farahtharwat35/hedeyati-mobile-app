

import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';

import '../../models/event.dart';

class LoadedLocalEvents extends ModelStates {
  final List<Event> events;

  LoadedLocalEvents(this.events);
}