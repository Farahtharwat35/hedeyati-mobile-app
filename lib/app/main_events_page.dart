import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:async_builder/async_builder.dart';
import '../bloc/events/event_bloc.dart';
import '../bloc/events/event_bloc_events.dart';
import '../models/event.dart';
import '../app/app_theme.dart';


class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  late TabController _mainTabController;
  late Stream<List<Event>> _currentStream;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _mainTabController.addListener(_onTabChanged);
    _updateStream();
  }

  @override
  void dispose() {
    _mainTabController.removeListener(_onTabChanged);
    _mainTabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_mainTabController.indexIsChanging) {
      print("---------------------- MAIN TAB CONTROLLER INDEX: ${_mainTabController.index} ----------------------");
      _updateStream();
    }
  }

  void _updateStream() {
    final eventBloc = BlocProvider.of<EventBloc>(context);
    if (_mainTabController.index == 0) {
      eventBloc.add(LoadMyEvents());
      _currentStream = eventBloc.myEventsStream;
      setState(() {});
      print("=======================Events Stream: $_currentStream ======================");
    } else {
      eventBloc.add(LoadFriendsEvents());
      _currentStream = eventBloc.friendsEventsStream;
      setState(() {});
      print("======================= !!!!!!!!!!!!!!!!! Friends Events Stream: $_currentStream ======================");
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
            child: AsyncBuilder<List<Event>>(
              stream: _currentStream,
              waiting: (context) => const Center(child: CircularProgressIndicator()),
              error: (context, error, stack) {
                debugPrint('Error: $error');
                debugPrint('Stack Trace: $stack');
                return Center(child: Text('Error: $error'),);
                },
              builder: (context, events) {
                return _buildEventsCard(context, events ?? []);
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
            backgroundImage: NetworkImage(event.image?.isNotEmpty == true
                ? event.image
                : 'https://th.bing.com/th/id/R.38be526e30e3977fb59c88f6bdc21693?rik=JeWAtcDhYBB8Qg&riu=http%3a%2f%2fsomethingdifferentcompanies.com%2fwp-content%2fuploads%2f2016%2f06%2fevent-image.jpeg&ehk=zyr0vwrJU%2fDm%2bLN0rSy8QnSUSlmBCS%2bRxG7AeymborI%3d&risl=&pid=ImgRaw&r=0'),
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
