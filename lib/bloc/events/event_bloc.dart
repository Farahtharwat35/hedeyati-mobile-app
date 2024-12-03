import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/events/event_bloc_events.dart';
import 'package:hedeyati/bloc/events/event_bloc_states.dart';
import 'package:hedeyati/helpers/userCredentials.dart';
import 'package:hedeyati/models/event.dart';

// class EventBloc extends Bloc<Event_E, EventState> {
//   EventBloc() : super(EventInitial());
//
//   Stream<EventState> mapEventToState(Event_E eventE) async* {
//     if (eventE is LoadMyEvents) {
//       yield EventsLoading(); // Emit loading state
//       try {
//         final querySnapshot = await Event.getMyEvents(UserCredentials.getCredentials());
//         final events = querySnapshot.docs.map((doc) => doc.data()).toList();
//         yield MyEventsLoaded(events: events); // Emit loaded state with data
//       } catch (e) {
//         yield EventsError(message: e.toString()); // Emit error state
//       }
//     } else if (eventE is LoadFriendsEvents) {
//       yield EventsLoading(); // Emit loading state
//       try {
//         final querySnapshot = await Event.getFriendsEvents(UserCredentials.getCredentials());
//         final events = querySnapshot.docs.map((doc) => doc.data()).toList();
//         yield FriendsEventsLoaded(events: events); // Emit loaded state with data
//       } catch (e) {
//         yield EventsError(message: e.toString()); // Emit error state
//       }
//     } else if (eventE is AddEvent) {
//       yield EventsLoading(); // Emit loading state
//       try {
//         await Event.addEvent(eventE.event);
//         yield EventCreated(message: "Event added successfully"); // Emit created state
//       } catch (e) {
//         yield EventsError(message: e.toString()); // Emit error state
//       }
//     } else if (eventE is UpdateEvent) {
//       yield EventsLoading(); // Emit loading state
//       try {
//         await Event.updateEvent(eventE.updatedEvent.firestoreID, eventE.updatedEvent);
//         yield EventUpdated(message: "Event updated successfully"); // Emit updated state
//       } catch (e) {
//         yield EventsError(message: e.toString()); // Emit error state
//       }
//     } else if (eventE is DeleteEvent) {
//       yield EventsLoading(); // Emit loading state
//       try {
//         await Event.deleteEvent(eventE.event.firestoreID);
//         yield EventDeleted(message: "Event deleted successfully"); // Emit deleted state
//       } catch (e) {
//         yield EventsError(message: e.toString()); // Emit error state
//       }
//     }
//   }
// }

class EventBloc extends Bloc<Event_E, EventState> {
  EventBloc() : super(EventInitial()) {
    // Register handlers for each event
    on<LoadMyEvents>((event, emit) async {
      emit(EventsLoading()); // Emit loading state
      try {
        final querySnapshot = await Event.getMyEvents(UserCredentials.getCredentials());
        final events = querySnapshot.docs.map((doc) => doc.data()).toList();
        emit(MyEventsLoaded(events: events)); // Emit loaded state with data
      } catch (e) {
        emit(EventsError(message: e.toString())); // Emit error state
      }
    });

    on<LoadFriendsEvents>((event, emit) async {
      emit(EventsLoading()); // Emit loading state
      try {
        final querySnapshot = await Event.getFriendsEvents(UserCredentials.getCredentials());
        final events = querySnapshot.docs.map((doc) => doc.data()).toList();
        emit(FriendsEventsLoaded(events: events)); // Emit loaded state with data
      } catch (e) {
        emit(EventsError(message: e.toString())); // Emit error state
      }
    });

    on<AddEvent>((event, emit) async {
      emit(EventsLoading()); // Emit loading state
      try {
        await Event.addEvent(event.event);
        emit(EventCreated(message: "Event added successfully")); // Emit created state
      } catch (e) {
        emit(EventsError(message: e.toString())); // Emit error state
      }
    });

    on<UpdateEvent>((event, emit) async {
      emit(EventsLoading()); // Emit loading state
      try {
        await Event.updateEvent(event.updatedEvent.firestoreID, event.updatedEvent);
        emit(EventUpdated(message: "Event updated successfully")); // Emit updated state
      } catch (e) {
        emit(EventsError(message: e.toString())); // Emit error state
      }
    });

    on<DeleteEvent>((event, emit) async {
      emit(EventsLoading()); // Emit loading state
      try {
        await Event.deleteEvent(event.event.firestoreID);
        emit(EventDeleted(message: "Event deleted successfully")); // Emit deleted state
      } catch (e) {
        emit(EventsError(message: e.toString())); // Emit error state
      }
    });
  }
}
