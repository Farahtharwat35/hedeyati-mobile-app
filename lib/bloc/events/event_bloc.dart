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
    on<LoadMyEvents>(_handleLoadMyEvents);
    on<LoadFriendsEvents>(_handleLoadFriendsEvents);
    on<AddEvent>(_handleAddEvent);
    on<UpdateEvent>(_handleUpdateEvent);
    on<DeleteEvent>(_handleDeleteEvent);
  }

  Future<void> _handleLoadMyEvents(LoadMyEvents event, Emitter<EventState> emit) async {
    emit(EventsLoading());
    try {
      final events = await _fetchUserEvents();
      emit(MyEventsLoaded(events: events));
    } catch (e) {
      // Log and check the type of error
      print("Error: $e");

      // Ensure you're passing a proper string error message
      String errorMessage = e is String ? e : e.toString();
      emit(EventsError(message: errorMessage));
      throw(e);
    }
  }

  Future<void> _handleLoadFriendsEvents(LoadFriendsEvents event, Emitter<EventState> emit) async {
    emit(EventsLoading());
    final events = await _fetchFriendsEvents();
    try {
      emit(FriendsEventsLoaded(events: events));
    } catch (e) {
      // Log and check the type of error
      print("Error: $e");

      // Ensure you're passing a proper string error message
      String errorMessage = e is String ? e : e.toString();
      emit(EventsError(message: errorMessage));
      throw(e);
    }
  }

  Future<void> _handleAddEvent(AddEvent event, Emitter<EventState> emit) async {
    emit(EventsLoading());
    try {
      await Event.addEvent(event.event);
      emit(EventActionSuccess(message: "Event added successfully"));
    } catch (e) {
      emit(EventsError(message: e.toString()));
      throw(e);
    }
  }

  Future<void> _handleUpdateEvent(UpdateEvent event, Emitter<EventState> emit) async {
    emit(EventsLoading());
    try {
      await Event.updateEvent(event.updatedEvent.firestoreID, event.updatedEvent);
      emit(EventActionSuccess(message: "Event updated successfully"));
    } catch (e) {
      emit(EventsError(message: e.toString()));
      throw(e);
    }
  }

  Future<void> _handleDeleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
    emit(EventsLoading());
    try {
      await Event.deleteEvent(event.event.firestoreID);
      emit(EventActionSuccess(message: "Event deleted successfully"));
    } catch (e) {
      emit(EventsError(message: e.toString()));
      throw(e);
    }
  }

  Future<List<Event>> _fetchUserEvents() async {
    final querySnapshot = await Event.getMyEvents(await UserCredentials.getCredentials());
    return querySnapshot.docs.map((doc) => doc.data() as Event)
        .whereType<Event>()
        .toList();
  }

  Future<List<Event>> _fetchFriendsEvents() async {
    final querySnapshot = await Event.getFriendsEvents(await UserCredentials.getCredentials());
    return querySnapshot.docs.map((doc) => doc.data() as Event)
        .whereType<Event>()
        .toList();
  }
}
