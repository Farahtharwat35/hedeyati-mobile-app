
import 'package:equatable/equatable.dart';

abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventsLoading extends EventState {}

class MyEventsLoaded extends EventState {
  final List<dynamic> events;

  MyEventsLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class FriendsEventsLoaded extends EventState {
  final List<dynamic> events;

  FriendsEventsLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class EventsError extends EventState {
  final String message;

  EventsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EventCreated extends EventState {
  final String message;

  EventCreated({required this.message});

  @override
  List<Object?> get props => [message];
}

class EventUpdated extends EventState {
  final String message;

  EventUpdated({required this.message});

  @override
  List<Object?> get props => [message];
}

class EventDeleted extends EventState {
  final String message;

  EventDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}


