import 'package:hedeyati/models/event.dart';
import '../generic_bloc_event.dart';

class Event_E extends BlocEvent {
  @override
  List<Object?> get props => [];
}

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

class LoadMyEvents extends Event_E {
  final int id;
  LoadMyEvents(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadFriendsEvents extends Event_E {
  final int id;
  LoadFriendsEvents(this.id);

  @override
  List<Object?> get props => [id];
}

