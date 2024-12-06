import 'package:equatable/equatable.dart';
import 'package:hedeyati/models/event.dart';

abstract class Event_E extends Equatable {
  @override
  List<Object?> get props => [];
}


class LoadMyEvents extends Event_E {}

class LoadFriendsEvents extends Event_E {}

class AddEvent extends Event_E {
  final Event event;

  AddEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class UpdateEvent extends Event_E {
  final Event updatedEvent;

  UpdateEvent(this.updatedEvent);

  @override
  List<Object?> get props => [updatedEvent];
}

class DeleteEvent extends Event_E {
  final Event event;

  DeleteEvent(this.event);

  @override
  List<Object?> get props => [event];
}
