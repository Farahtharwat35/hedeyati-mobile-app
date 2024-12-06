import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../bloc/events/event_bloc.dart';
import '../bloc/events/event_bloc_events.dart';
import '../bloc/events/event_bloc_states.dart';
import '../models/event.dart';

class EventsListPage extends StatelessWidget {
  final String filter;

  const EventsListPage({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    print("--------------------EventsListPage: Filter is $filter==============");

    // Trigger Bloc event based on the filter
    final bloc = BlocProvider.of<EventBloc>(context);
    if (filter == 'My Events') {
      bloc.add(LoadMyEvents());
    } else if (filter == 'Others Events') {
      bloc.add(LoadFriendsEvents());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(filter),
      ),
      body: _buildEventsListView(context),
    );
  }

  Widget _buildEventsListView(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        print("==================STATE IS $state=====================");
        if (state is EventsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EventsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is MyEventsLoaded || state is FriendsEventsLoaded) {
          final events = state is MyEventsLoaded ? state.events : (state as FriendsEventsLoaded).events;

          return events.isEmpty
              ? const Center(child: Text('No events found.'))
              : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return _buildEventTile(context, events[index]);
            },
          );
        }

        return const Center(child: Text('No events found.'));
      },
    );
  }

  Widget _buildEventTile(BuildContext context, Event event) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(event.image),
        radius: 25,
      ),
      title: Text(event.description),
      subtitle: Text(
        "${event.startDate.day}/${event.startDate.month}/${event.startDate.year}",
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to the Edit Event page
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(context, event);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete the event "${event.description}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<EventBloc>(context).add(DeleteEvent(event));
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
