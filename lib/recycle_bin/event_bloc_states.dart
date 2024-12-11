import 'package:hedeyati/models/event.dart';
import '../bloc/generic_bloc/generic_states.dart';


class MyEventsLoaded extends ModelStates {
  final List<Event> events;

  const MyEventsLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class FriendsEventsLoaded extends ModelStates {
  final List<Event> events;

  const FriendsEventsLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class EventStreamLoaded extends ModelStates {
  final Stream<List<Event>> eventStream;
  const EventStreamLoaded({required this.eventStream});

  @override
  List<Object?> get props => [eventStream];
}

