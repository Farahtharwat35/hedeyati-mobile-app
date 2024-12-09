import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/events/event_bloc.dart';
import '../bloc/events/event_bloc_events.dart';
import '../bloc/events/event_bloc_states.dart';
import '../models/event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  late TabController _mainTabController;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _mainTabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _mainTabController.removeListener(_onTabChanged);
    _mainTabController.dispose();
    super.dispose();
  }

  Future<void> _onTabChanged() async {
    if (_mainTabController.indexIsChanging) {
      final filter = _mainTabController.index == 0 ? 'My Events' : 'Others Events';
      context.read<EventBloc>().add(
        filter == 'My Events' ? LoadMyEvents() : LoadFriendsEvents(),
      );
      print("Filter is $filter");
      print("--------------TAB SWITCHED--------------");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TabBar(
              controller: _mainTabController,
              tabs: const [
                Tab(text: 'My Events'),
                Tab(text: 'Others Events'),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EventsError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is MyEventsLoaded || state is FriendsEventsLoaded) {
                  final events = state is MyEventsLoaded
                      ? state.events
                      : (state as FriendsEventsLoaded).events;

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
            ),
          ),
        ],
      ),
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
