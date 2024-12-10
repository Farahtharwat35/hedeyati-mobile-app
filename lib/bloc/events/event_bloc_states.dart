import 'package:equatable/equatable.dart';
import 'package:hedeyati/models/event.dart';


abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventsLoading extends EventState {}

class MyEventsLoaded extends EventState {
  final List<Event> events;

  MyEventsLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class FriendsEventsLoaded extends EventState {
  final List<Event> events;

  FriendsEventsLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class EventActionSuccess extends EventState {
  final String message;

  EventActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class EventsError extends EventState {
  final String message;

  EventsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EventStreamLoaded extends EventState {
  final Stream<List<Event>> eventStream;
  EventStreamLoaded(this.eventStream);

  @override
  List<Object?> get props => [eventStream];
}

