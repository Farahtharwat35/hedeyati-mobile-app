import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';
import '../app/app_theme.dart';
import '../bloc/events/event_bloc.dart';
import '../bloc/events/event_bloc_events.dart';
import 'package:async_builder/async_builder.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  late TabController _mainTabController;
  late Stream<QuerySnapshot> currentStream;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _mainTabController.addListener(_onTabChanged);

    // Initialize the first stream
    currentStream = _getStreamForTab(0);
  }

  @override
  void dispose() {
    _mainTabController.removeListener(_onTabChanged);
    _mainTabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_mainTabController.indexIsChanging) {
      currentStream = _getStreamForTab(_mainTabController.index);
      setState(() {});
    }
  }

  Future<Stream<QuerySnapshot>> _getStreamForTab(int tabIndex) async {
    final eventBloc = context.read<EventBloc>();
    if (tabIndex == 0) {
      return eventBloc.add(await LoadMyEvents());
    } else {
      return eventBloc.add(await LoadFriendsEvents()) as Stream<QuerySnapshot>;
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
            child: AsyncBuilder<QuerySnapshot>(
              stream: currentStream,
              waiting: (context) => const Center(child: CircularProgressIndicator()),
              builder: (context, data) {
                if (data == null || data.docs.isEmpty) {
                  return const Center(child: Text('No events found.'));
                }
                final events = data.docs
                    .map((doc) => Event.fromJson(doc.data() as Map<String, dynamic>))
                    .toList();
                return _buildEventsCard(context, events);
              },
              error: (context, error, stackTrace) => Center(child: Text('Error: $error')),
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
        color: Colors.pink[50],
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
                child: Text(
                  _mainTabController.index == 0 ? 'My Events' : 'My Friends Events',
                  style: myTheme.textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 16),
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
                  event.name,
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
