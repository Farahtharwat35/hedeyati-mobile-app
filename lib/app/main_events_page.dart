import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/events/event_bloc.dart';
import '../bloc/events/event_bloc_events.dart';
import '../bloc/events/event_bloc_states.dart';
import '../models/event.dart';
import '../app/app_theme.dart';

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                if (state is EventInitial) {
                  // Trigger the event to load the events
                  _mainTabController.index == 0
                      ? context.read<EventBloc>().add(LoadMyEvents())
                      : context.read<EventBloc>().add(LoadFriendsEvents());
                }
                if (state is EventsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EventsError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is MyEventsLoaded) {
                  final events = state.events;
                  return _buildEventsCard(context, events);
                } else if (state is FriendsEventsLoaded) {
                  final events = state.events;
                  return _buildEventsCard(context, events);
                }
                // Handle any other states (just in case)
                return const SizedBox.shrink(); // Empty widget if the state doesn't match
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsCard(BuildContext context, List<Event> events) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.pink[50], // Light pink background color.
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _mainTabController.index ==0 ?  Text(
                  'My Events',
                  style: myTheme.textTheme.headlineMedium, // Use `myTheme` for the title.
                ) : Text(
                  'My Friends Events',
                  style: myTheme.textTheme.headlineMedium, // Use `myTheme` for the title.
                ),
              ),
              const SizedBox(height: 16),
              // Check if the events list is empty, and show appropriate widget
              if (events.isEmpty)
              const Center(child: Text('No events found.'))
              else
                ...events.map((event) => _buildEventTile(context, event)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(event.image),
            radius: 25,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${event.startDate.day}/${event.startDate.month}/${event.startDate.year}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.pinkAccent),
            onPressed: () {
              // Navigate to the Edit Event page
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.black45),
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
